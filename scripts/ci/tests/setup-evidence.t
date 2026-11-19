use strict;
use warnings;
use Test::More;
use Cwd qw(abs_path getcwd);
use File::Path qw(make_path);
use File::Temp qw(tempdir);
use JSON::PP;

my $root=abs_path('.');
my $helper="$root/scripts/ci/setup-evidence.pl";
make_path("$root/target/qualification");
my $work=tempdir('setup-evidence.XXXXXX',DIR=>"$root/target/qualification",CLEANUP=>0);
chdir $work or die $!;
sub run {
    my ($output,@args)=@_;
    my $pid=fork(); defined($pid) or die $!;
    if (!$pid) {open STDOUT,'>',$output or die $!;open STDERR,'>&',STDOUT or die $!;exec @args;die $!;}
    waitpid($pid,0);return $? >> 8;
}
sub read_file {open my $fh,'<',$_[0] or die $!;local $/;return <$fh> // '';}
$ENV{FIXTURE_SECRET_TOKEN}='fixture-value-must-not-be-published'; # gitleaks:allow synthetic redaction input
$ENV{FIXTURE_AUTHORIZATION}="opaque-auth-line\nopaque-auth-second";
$ENV{FIXTURE_ACCESS_KEY}='opaque-access-value';
my $code=q{
    print "noise line $_\n" for 1..12000;
    print "underlying parser: archive has an invalid header\n";
    print "authorization: Bearer fixture-auth\n";
    print "request failed with Bearer opaque-bearer-value\n";
    print 'response {"payload":"opaque-payload-value"}', "\n";
    print "TOKEN=fixture-env\n";
    print "request uses $ENV{FIXTURE_SECRET_TOKEN}\n";
    print "$ENV{FIXTURE_AUTHORIZATION}\n$ENV{FIXTURE_ACCESS_KEY}\n";
    print "https://user:password\@example.invalid/archive\n";
    print "download failed: https://example.invalid/#opaque-canary-value\n";
    print "download failed: HTTPS://example.invalid/file?q=opaque-query-value\n";
    print "-----BEGIN PRIVATE KEY-----\nfixture-private-material\n-----END PRIVATE KEY-----\n"; # gitleaks:allow synthetic redaction input
    print "github token ghp_fixturecredential\n";
    exit 43;
};
is(run('failure.out',$^X,$helper,'target/evidence/native-ci','host-tools',$^X,'-e',$code),43,
    'setup failure retains the original status');
my $log=read_file('target/evidence/native-ci/.setup/host-tools.log');
my $meta=decode_json(read_file('target/evidence/native-ci/.setup/host-tools.json'));
is($meta->{status},43,'hidden attempt records original status');
ok($meta->{bounded},'bounded diagnostic retention is explicit');
is($meta->{retained_bytes},length($log),'metadata counts the retained sanitized bytes');
cmp_ok(length($log),'<=',64*1024,'retained log is bounded');
cmp_ok(length(read_file('failure.out')),'<',5000,'printed excerpt is bounded');
like($log,qr/underlying parser: archive has an invalid header/,'underlying failure is useful');
for my $payload ('fixture-auth','opaque-bearer-value','opaque-payload-value',
    'fixture-env',$ENV{FIXTURE_SECRET_TOKEN},'user:password',
    'fixture-private-material','ghp_fixturecredential','opaque-canary-value','opaque-query-value',
    'opaque-auth-line','opaque-auth-second','opaque-access-value') {
    unlike($log,qr/\Q$payload\E/,'retained log excludes a sensitive field');
    unlike(read_file('failure.out'),qr/\Q$payload\E/,'printed excerpt excludes a sensitive field');
}
make_path('target/evidence/native-ci/unrelated');
open my $unrelated,'>','target/evidence/native-ci/unrelated/token.log' or die $!;
print {$unrelated} 'unrelated-secret';close $unrelated;
is(run('collect.out',$^X,$helper,'--collect','target/evidence/native-ci','target/evidence/native-diagnostics.tar.gz'),0,
    'collector archives selected sanitized hidden files');
is(run('members.out','tar','-tzf','target/evidence/native-diagnostics.tar.gz'),0,'archive is readable');
my $members=read_file('members.out');
like($members,qr{\.setup/host-tools.log},'hidden attempt log is retained');
unlike($members,qr{unrelated|scratch|\.tools/},'unrelated payloads are excluded');
is(run('archived-log.out','tar','-xOzf','target/evidence/native-diagnostics.tar.gz','.setup/host-tools.log'),0,
    'read the actual archived diagnostic');
is(read_file('archived-log.out'),$log,'archive contains the exact sanitized log');
unlike(read_file('archived-log.out'),qr/opaque-canary-value|opaque-query-value/,
    'URL fragments and queries are absent from the uploaded payload');
isnt(run('missing.out',$^X,$helper,'--collect','target/evidence/missing','target/evidence/missing.tar.gz'),0,
    'missing evidence fails collection');
like(read_file('missing.out'),qr/setup diagnostics missing/,'missing diagnostics are explicit');
make_path('target/evidence/oversized/.setup');
open my $large,'>','target/evidence/oversized/.setup/phase.log' or die $!;print {$large} 'x' x (64*1024+1);close $large;
open my $large_meta,'>','target/evidence/oversized/.setup/phase.json' or die $!;print {$large_meta} '{}';close $large_meta;
isnt(run('oversized.out',$^X,$helper,'--collect','target/evidence/oversized','target/evidence/oversized.tar.gz'),0,
    'collector refuses an oversized selected file');
ok(!-e 'target/evidence/oversized.tar.gz','oversized input is not archived');
make_path('target/evidence/symlink/.setup');
symlink "$work/target/evidence/native-ci/unrelated/token.log",'target/evidence/symlink/.setup/host.log' or die $!;
open my $link_meta,'>','target/evidence/symlink/.setup/host.json' or die $!;print {$link_meta} '{}';close $link_meta;
isnt(run('symlink.out',$^X,$helper,'--collect','target/evidence/symlink','target/evidence/symlink.tar.gz'),0,
    'collector refuses symlink input');
ok(!-e 'target/evidence/symlink.tar.gz','symlink target was not archived');
make_path('bin');
open my $tar,'>','bin/tar' or die $!;print {$tar} "#!/bin/sh\nexit 31\n";close $tar;chmod 0755,'bin/tar';
{
    local $ENV{PATH}="$work/bin:$ENV{PATH}";
    isnt(run('collector-failure.out',$^X,$helper,'--collect','target/evidence/native-ci','target/evidence/failed.tar.gz'),0,
        'archiver failure remains a collection failure');
}
is($meta->{status},43,'collection cannot relabel the original setup failure');
like(read_file('collector-failure.out'),qr/setup diagnostic archive failed/,'collector failure is explicit');
is(run('empty.out',$^X,$helper,'target/evidence/empty','empty',$^X,'-e','exit 44'),44,
    'missing command diagnostics retain original failure status');
like(read_file('empty.out'),qr/no usable diagnostic output/,'empty stderr/stdout is explicit');
make_path('target/evidence/occupied/.setup');
open my $occupied,'>','target/evidence/occupied/.setup/phase.json' or die $!;close $occupied;
is(run('occupied.out',$^X,$helper,'target/evidence/occupied','phase',$^X,'-e','exit 43'),43,
    'diagnostic write failure cannot replace the original failing status');
like(read_file('occupied.out'),qr/Setup evidence collection failed/,'diagnostic write failure is reported separately');

# Execute the actual scanner setup body with its external download substituted.
make_path('scripts/ci','vendor/toko-tooling/scripts/ci');
symlink $helper,'scripts/ci/setup-evidence.pl' or die $!;
open my $installer,'>','vendor/toko-tooling/scripts/ci/install-ci-tool.sh' or die $!;
print {$installer} "#!/bin/sh\necho 'scanner checksum mismatch' >&2\nexit 43\n";close $installer;
is(run('scanner-body.json',"$root/.tools/host/bin/yq",'-o=json',
    '.jobs.security.steps[] | select(.id == "scanner")',"$root/.github/workflows/ci.yml"),0,'read actual scanner workflow body');
my $scanner=decode_json(read_file('scanner-body.json'));
local $ENV{RUNNER_TEMP}="$work/runner-temp";
local $ENV{GITHUB_ENV}="$work/github-env";
is(run('scanner.out','bash','-e','-o','pipefail','-c',$scanner->{run}),43,
    'scanner workflow preserves download failure through command substitution');
like(read_file('target/evidence/security-setup/.setup/scanner.log'),qr/checksum mismatch/,
    'scanner workflow retains underlying failure');
ok(!-e "$work/github-env",'failed scanner is not exported as an installed selection');
open my $recorder,'>','scripts/ci/record-native-inputs.sh' or die $!;
print {$recorder} "#!/bin/sh\necho 'missing tracked workflow source' >&2\nexit 43\n";close $recorder;
is(run('inputs-body.json',"$root/.tools/host/bin/yq",'-o=json',
    '.jobs.native.steps[] | select(.id == "native_inputs")',"$root/.github/workflows/ci.yml"),0,
    'read actual earliest native setup body');
my $inputs=decode_json(read_file('inputs-body.json'));
# Use a fresh native attempt, rather than overwrite the earlier host-tools case.
my $body=$inputs->{run}; $body =~ s{target/evidence/native-ci}{target/evidence/input-setup};
is(run('inputs.out','bash','-e','-o','pipefail','-c',$body),43,
    'failure before host/tool setup retains the original status');
like(read_file('target/evidence/input-setup/.setup/inputs.log'),qr/missing tracked workflow source/,
    'earliest setup failure has retrievable diagnostics');
is(run('prerequisites-body.json',"$root/.tools/host/bin/yq",'-o=json',
    '.jobs.native.steps[] | select(.id == "prerequisites")',"$root/.github/workflows/ci.yml"),0,
    'read actual prerequisite workflow body');
my $prerequisites=decode_json(read_file('prerequisites-body.json'));
for my $case (['Linux',0],['Linux',49],['Darwin',0],['Darwin',47],['Unsupported',1]) {
    my ($os,$status)=@$case;
    my $case_root="$work/prerequisites-$os-$status";
    make_path("$case_root/scripts/ci","$case_root/bin");
    symlink $helper,"$case_root/scripts/ci/setup-evidence.pl" or die $!;
    for my $tool (qw(uname sudo brew)) {
        open my $stub,'>',"$case_root/bin/$tool" or die $!;
        print {$stub} $tool eq 'uname' ? "#!/bin/sh\necho '$os'\n" :
            "#!/bin/sh\nprintf '%s\\n' \"\$*\" >> \"\$PREREQUISITE_COMMANDS\"\nexit $status\n";
        close $stub;chmod 0755,"$case_root/bin/$tool";
    }
    chdir $case_root or die $!;
    local $ENV{PATH}="$case_root/bin:$ENV{PATH}";
    local $ENV{PREREQUISITE_COMMANDS}="$case_root/commands";
    is(run('step.out','bash','-e','-o','pipefail','-c',$prerequisites->{run}),$status,
        "$os prerequisite body preserves status $status");
    my $record=decode_json(read_file('target/evidence/native-ci/.setup/prerequisites.json'));
    is($record->{status},$status,"$os prerequisite status is retained");
    if ($os eq 'Linux') {
        my $expected="apt-get update\n".($status ? '' : "apt-get install -y xz-utils perl\n");
        is(read_file('commands'),$expected,'Linux install follows successful update only');
    } elsif ($os eq 'Darwin') {is(read_file('commands'),"install xz\n",'Darwin selects brew installation');}
    else {like(read_file('step.out'),qr/unsupported native host/,'unsupported host reports its actual cause');}
}
chdir $root or die $!;
done_testing();
