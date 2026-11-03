#!/usr/bin/env perl
# Shared companions: scripts/ci/validation-evidence.pl ci/release-validation.json ci/cargo-release-groups.json
# Product scope and protected-receipt custody; Shared owns reusable observations.
use strict;
use warnings;
use FindBin qw($RealBin);
use lib "$RealBin/../ci";
use ValidationPlan qw(bytes digest document relative_path);
use JSON::PP;
use Cwd qw(abs_path);
use File::Path qw(make_path);
use File::Temp qw(tempdir);

my ($operation, $attempt, $requested_scope, $requested_group) = @ARGV;
defined($operation) && $operation =~ /\A(?:select|seal|check|admit|roster)\z/
    or die "usage: validation.pl roster | select|seal|check ATTEMPT | admit ATTEMPT SCOPE GROUP\n";
my $root = abs_path('.');
my $json = JSON::PP->new->canonical->utf8;
my $policy_path = 'ci/release-validation.json';
my $observer = "$RealBin/../ci/validation-evidence.pl";
sub observe {
    open my $in, '-|', @_ or die "start observation: $!\n";
    binmode $in;
    my $raw = '';
    while (1) {
        my $n = read $in, my $chunk, 65536;
        defined($n) or die "read observation: $!\n";
        last unless $n;
        $raw .= $chunk;
        length($raw) <= 4194304 or die "observation exceeds 4 MiB\n";
    }
    close $in or die "observation failed: @_\n";
    return $raw;
}
sub same { $json->encode($_[0]) eq $json->encode($_[1]) or die "$_[2]\n" }
sub write_document {
    my ($path, $value) = @_;
    relative_path($path);
    !-e $path && !-l $path or die "refusing to replace evidence: $path\n";
    open my $out, '>:raw', $path or die "write $path: $!\n";
    print {$out} $json->encode($value), "\n" or die "write document: $!\n";
    close $out or die "close document: $!\n";
}
my $groups = $json->decode(bytes($root, 'ci/cargo-release-groups.json'));
for (@{$groups->{groups}}) {
    $_->{name} =~ /\A(?:metrics|logging)\z/ or die "unknown product release group\n";
    same($_->{members}, ["ic-$_->{name}"], 'release-group membership needs a new validation mapping');
    $_->{primary} eq "ic-$_->{name}" or die "release-group primary needs a new validation mapping\n";
}
if ($operation eq 'roster') {
    @ARGV == 1 or die "roster takes no selection arguments\n";
    for ('target', 'target/qualification') { !-l $_ or die "symlink in roster output path\n"; }
    make_path('target/qualification');
    my $directory = tempdir('roster.XXXXXX', DIR=>'target/qualification', CLEANUP=>1);
    write_document("$directory/groups.json", [map { $_->{name} } @{$groups->{groups}}]);
    print observe($^X, $observer, 'roster', $root, $policy_path, "$directory/groups.json");
    exit;
}
(@ARGV == 2 || @ARGV == 4 && $operation eq 'admit')
    && defined($attempt) && $attempt =~ m{\Atarget/release-validation/[A-Za-z0-9_.-]+\z}
    or die "invalid validation selection arguments\n";
my $source = $ENV{RELEASE_SOURCE} // '';
my $group = $ENV{RELEASE_GROUP} // '';
my $previous = $ENV{RELEASE_PREVIOUS} // '';
$source =~ /\A(?:[0-9a-f]{40}|[0-9a-f]{64})\z/ && $group =~ /\A(?:metrics|logging)\z/
    && $previous =~ /\A\d+\.\d+\.\d+\z/ or die "invalid release selection\n";
my $context_path = "$attempt/context.json";
my $plan_path = "$attempt/plan.json";
my $names_path = "$attempt/groups.json";
if ($operation eq 'admit') {
    my $plan = document($root, $plan_path);
    $plan->{source} eq $source && $plan->{group} eq $requested_group
        && $plan->{scope} eq $requested_scope or die "Make selection differs from admitted release plan\n";
    exit;
}
if ($operation eq 'select') {
    observe(qw(git rev-parse --verify HEAD)) eq "$source\n" or die "release source moved\n";
    relative_path($attempt);
    for ('target', 'target/release-validation', $attempt) { !-l $_ or die "symlink in attempt path\n"; }
    make_path($attempt);
    write_document($names_path, [map { $_->{name} } @{$groups->{groups}}]);
}
my @targets = split /\n/, observe($^X, $observer, 'roster', $root, $policy_path, $names_path);
sub configuration {
    my @keys = grep {
        /\A(?:RUSTFLAGS|CARGO_ENCODED_RUSTFLAGS|RUSTDOCFLAGS|RUSTC|RUSTDOC|RUSTC_WRAPPER|RUSTC_WORKSPACE_WRAPPER|RUSTUP_TOOLCHAIN|CARGO_HOME|CARGO_TARGET_DIR|CARGO_BUILD_TARGET|CC|CXX|AR|LD)\z/
            || /\A(?:CARGO_PROFILE_|CARGO_TARGET_|CARGO_BUILD_|CC_|CXX_|AR_)/
    } keys %ENV;
    return {rustc=>observe(qw(rustc -vV)), cargo=>observe(qw(cargo -vV)),
        host=>observe(qw(uname -sm)), environment=>{map { $_=>$ENV{$_} } @keys}};
}
sub selection {
    my $baseline = $json->decode(observe($^X, $observer, 'baseline', $root,
        $source, "refs/tags/$group-v$previous"));
    my @shared = grep {
        $_ !~ m{\Acrates/ic-\Q$group\E/(?:src/.*\.(?:rs|md)|(?:examples|tests)/.*\.rs|README\.md|CHANGELOG\.md)\z}
            && $_ ne "releases/$group/CHANGELOG.md"
    } @{$baseline->{changes}};
    my $scope = $baseline->{available} && !@shared ? 'group' : 'workspace';
    return {schema=>1, root=>$root, source=>$source, group=>$group, previous=>$previous, baseline=>$baseline,
        scope=>$scope, reason=>!$baseline->{available} ? 'No admitted annotated ancestor release baseline'
            : @shared ? 'Shared or uncertain inputs changed since the selected release'
            : 'Independent library implementation/docs only; dependency and shared inputs unchanged',
        configuration=>configuration()};
}
sub plan {
    my ($context) = @_;
    my @stages;
    for my $target (@targets) {
        my $owner = $target eq 'logging-profiles-check' ? 'logging'
            : $target =~ /\A(?:metrics-profiles-check|allocation-free-check)\z/ ? 'metrics' : '';
        my $required = $context->{scope} eq 'workspace' || !$owner || $owner eq $group;
        push @stages, {target=>$target, required=>$required ? JSON::PP::true : JSON::PP::false,
            reason=>!$required ? "Unchanged independent $owner package; no dependency or shared-input changes"
                : $context->{scope} eq 'workspace' ? $context->{reason}
                : "Common admission or selected $group package; native/Wasm and all features retained"};
    }
    my @inputs = split /\0/, observe(qw(git ls-tree -rz --name-only), $source);
    return {schema=>1, source=>$source, group=>$group, scope=>$context->{scope},
        policy=>$policy_path, inputs=>[@inputs, $names_path, $context_path], stages=>\@stages};
}
if ($operation eq 'select') {
    my $context = selection();
    write_document($context_path, $context);
    write_document($plan_path, plan($context));
    print "$plan_path\n";
    exit;
}
my $context = document($root, $context_path);
same($context, selection(), 'release baseline, scope or host/configuration changed; validate afresh');
same(document($root, $plan_path), plan($context), 'release validation plan changed');
if ($operation eq 'seal') {
    my @runs = glob "$attempt/logs/validation.*";
    @runs == 1 && -d $runs[0] && !-l $runs[0] or die "missing or ambiguous validation execution\n";
    # Parent publishes this result atomically through release_receipt_write.
    print observe($^X, $observer, 'verify', $root, $plan_path, $source, $group, $runs[0], $context_path);
} else {
    # The parent first admits the protected receipt's proof hash. After version
    # preparation, retain that verified proof and check byte custody instead of
    # projecting prepared metadata or relocating/reinterpreting runner records.
    my $proof = document($root, "$attempt/proof.json");
    $proof->{schema} == 1 && $proof->{kind} eq 'group-validation-evidence'
        && $proof->{source} eq $source && $proof->{group} eq $group
        && $proof->{scope} eq $context->{scope} or die "wrong sealed validation identity\n";
    for my $path ($plan_path, $policy_path, $context_path, $names_path) {
        digest($root, $path) eq $proof->{inputs}{$path} or die "sealed validation input changed\n";
    }
    for my $file (keys %{$proof->{files}}) {
        digest($root, "$proof->{run}/$file") eq $proof->{files}{$file}
            or die "sealed validation evidence changed\n";
    }
}
