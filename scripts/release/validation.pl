#!/usr/bin/env perl
# Consumer policy and receipt admission; Shared Tooling owns plan execution.
use strict;
use warnings;
use JSON::PP;
use Digest::SHA qw(sha256_hex);
use File::Path qw(make_path);

my ($operation, $attempt, $requested_scope, $requested_group) = @ARGV;
(@ARGV == 2 || @ARGV == 4 && $operation eq 'admit') && $operation =~ /\A(?:select|seal|check|admit)\z/
    && $attempt =~ m{\Atarget/release-validation/[A-Za-z0-9_.-]+\z}
    or die "usage: validation.pl select|seal|check target/release-validation/ATTEMPT\n";
my $json = JSON::PP->new->canonical->utf8;
my $policy_path = 'ci/release-validation.json';
my $source = $ENV{RELEASE_SOURCE} // '';
my $group = $ENV{RELEASE_GROUP} // '';
my $previous = $ENV{RELEASE_PREVIOUS} // '';
$source =~ /\A(?:[0-9a-f]{40}|[0-9a-f]{64})\z/ && $group =~ /\A(?:metrics|logging)\z/
    && $previous =~ /\A\d+\.\d+\.\d+\z/ or die "invalid release selection\n";

sub observe {
    open my $in, '-|', @_ or die "start observation: $!\n";
    local $/;
    my $value = <$in> // '';
    close $in or die "observation failed: @_\n";
    return $value;
}
sub route {
    my ($path) = @_;
    $path !~ m{\A/|(?:\A|/)\.{1,2}(?:/|\z)|//|[\x00\t\r\n]}
        or die "invalid evidence path\n";
    my $route = '';
    for (split m{/}, $path) {
        $route .= length($route) ? "/$_" : $_;
        !-l $route or die "symlink in evidence route\n";
    }
}
sub regular {
    route($_[0]);
    -f $_[0] or die "missing evidence: $_[0]\n";
}
sub read_file {
    my ($path) = @_;
    regular($path);
    open my $in, '<:raw', $path or die "read $path: $!\n";
    local $/;
    return <$in> // '';
}
sub document {
    my ($path) = @_;
    my $raw = read_file($path);
    my $value = $json->decode($raw);
    $raw eq $json->encode($value)."\n" or die "noncanonical JSON: $path\n";
    return $value;
}
sub write_document {
    my ($path, $value) = @_;
    route($path);
    !-e $path && !-l $path or die "refusing to replace evidence: $path\n";
    open my $out, '>:raw', $path or die "write $path: $!\n";
    print {$out} $json->encode($value), "\n" or die "write document: $!\n";
    close $out or die "close document: $!\n";
}
if ($operation eq 'admit') {
    my $plan = document("$attempt/plan.json");
    $plan->{source} eq $source && $plan->{group} eq $requested_group
        && $plan->{scope} eq $requested_scope or die "Make selection differs from admitted release plan\n";
    exit;
}
sub configuration {
    my @keys = grep {
        /\A(?:RUSTFLAGS|CARGO_ENCODED_RUSTFLAGS|RUSTDOCFLAGS|RUSTC|RUSTDOC|RUSTC_WRAPPER|RUSTC_WORKSPACE_WRAPPER|RUSTUP_TOOLCHAIN|CARGO_HOME|CARGO_TARGET_DIR|CARGO_BUILD_TARGET|CC|CXX|AR|LD)\z/
            || /\A(?:CARGO_PROFILE_|CARGO_TARGET_|CARGO_BUILD_|CC_|CXX_|AR_)/
    } keys %ENV;
    return { rustc => observe(qw(rustc -vV)), cargo => observe(qw(cargo -vV)),
        host => observe(qw(uname -sm)), environment => {map { $_ => $ENV{$_} } @keys} };
}
sub same {
    $json->encode($_[0]) eq $json->encode($_[1]) or die "$_[2]\n";
}
my $policy = document($policy_path);
my $groups = $json->decode(read_file('ci/cargo-release-groups.json'));
same([sort @{$policy->{groups}}], [sort map { $_->{name} } @{$groups->{groups}}],
    'validation groups differ from Cargo release groups');
for (@{$groups->{groups}}) {
    same($_->{members}, ["ic-$_->{name}"], 'release-group membership needs a new validation mapping');
    $_->{primary} eq "ic-$_->{name}" or die "release-group primary needs a new validation mapping\n";
}
my $makefile = read_file('Makefile');
my @definitions = $makefile =~ /^ci:/mg;
my ($ci) = $makefile =~ /^ci:\n((?:\t[^\n]*\n)+)/m;
@definitions == 1 && defined($ci) or die "missing or ambiguous full CI recipe\n";
my @full;
for (split /\n/, $ci) {
    my ($target) = /^\t\+\$\(MAKE\) --no-print-directory ([a-z0-9-]+) OBSERVABILITY_RELEASE_VALIDATION_SCOPE=workspace$/;
    defined($target) or die "unreviewed full CI dispatch; update the validation roster\n";
    push @full, $target;
}
same(\@full, $policy->{stages}, 'full CI and validation roster differ');

sub selection {
    my $tag = "$group-v$previous";
    # Missing, lightweight or nonancestor release baselines cannot narrow scope.
    my $baseline = '';
    my $type = observe('git', 'for-each-ref', '--format=%(objecttype)', "refs/tags/$tag");
    if ($type eq "tag\n") {
        $baseline = observe('git', 'rev-parse', '--verify', "$tag^{commit}");
        chomp $baseline;
        if (system('git', 'merge-base', '--is-ancestor', $baseline, $source) != 0) { $baseline = ''; }
    }
    my @changed;
    if (length $baseline) {
        @changed = split /\0/, observe('git', 'diff', '--no-renames', '--name-only', '-z', $baseline, $source);
    }
    # Both groups are independent leaf libraries. No Cargo/feature, shared input,
    # generated identity, release machinery or unknown path can take this branch.
    my @shared = grep {
        $_ !~ m{\Acrates/ic-\Q$group\E/(?:src/.*\.(?:rs|md)|(?:examples|tests)/.*\.rs|README\.md|CHANGELOG\.md)\z}
            && $_ ne "releases/$group/CHANGELOG.md"
    } @changed;
    my $scope = length($baseline) && !@shared ? 'group' : 'workspace';
    my $reason = !length($baseline) ? 'No admitted annotated ancestor release baseline'
        : @shared ? 'Shared or uncertain inputs changed since the selected release'
        : 'Independent library implementation/docs only; dependency and shared inputs unchanged';
    return { schema => 1, source => $source, group => $group, previous => $previous,
        baseline_tag => $tag, baseline => $baseline, changed => \@changed,
        scope => $scope, reason => $reason, configuration => configuration() };
}
my @source_inputs = split /\0/, observe('git', 'ls-tree', '-rz', '--name-only', $source);
my $context_path = "$attempt/context.json";
my $plan_path = "$attempt/plan.json";
sub plan {
    my ($context) = @_;
    my @stages;
    for my $target (@{$policy->{stages}}) {
        my $owner = $target eq 'logging-profiles-check' ? 'logging'
            : $target =~ /\A(?:metrics-profiles-check|allocation-free-check)\z/ ? 'metrics' : '';
        my $required = $context->{scope} eq 'workspace' || !$owner || $owner eq $group;
        push @stages, { target => $target, required => $required ? JSON::PP::true : JSON::PP::false,
            reason => !$required ? "Unchanged independent $owner package; no dependency or shared-input changes"
                : $context->{scope} eq 'workspace' ? $context->{reason}
                : "Common admission or selected $group package; native/Wasm and all features retained" };
    }
    return { schema => 1, source => $source, group => $group, scope => $context->{scope},
        policy => $policy_path, inputs => [@source_inputs, $context_path], stages => \@stages };
}
if ($operation eq 'select') {
    observe('git', 'rev-parse', '--verify', 'HEAD') eq "$source\n" or die "release source moved\n";
    route($attempt);
    make_path($attempt);
    my $context = selection();
    write_document($context_path, $context);
    write_document($plan_path, plan($context));
    print "$plan_path\n";
    exit;
}

# Recovery regenerates the same selection and configuration, rather than treating
# a previous textual PASS or legacy full-gate identity as authority.
my $context = document($context_path);
same($context, selection(), 'release baseline, scope or host/configuration changed; validate afresh');
my $plan = document($plan_path);
same($plan, plan($context), 'release validation plan changed');
my @runs = glob "$attempt/logs/validation.*";
@runs == 1 && -d $runs[0] && !-l $runs[0] or die "missing or ambiguous validation execution\n";
my $run = $runs[0];
same(document("$run/parsed-inputs.json.plan.json"), $plan, 'runner admitted a different plan');
same(document("$run/parsed-inputs.json.policy.json"), $policy, 'runner admitted a different policy');
my $checkpoint = document("$run/plan-inputs.json");
my %expected = map { $_ => sha256_hex(observe('git', 'show', "$source:$_")) } @source_inputs;
$expected{$context_path} = sha256_hex(read_file($context_path));
$expected{$plan_path} = sha256_hex(read_file($plan_path));
same($checkpoint, \%expected, 'validation checkpoint is incomplete or differs from the admitted source');
for my $path ((glob "$run/*-before-inputs.json"), (glob "$run/*-after-inputs.json")) {
    same(document($path), $checkpoint, 'validation observed source/input drift');
}
my @required = grep { $_->{required} } @{$plan->{stages}};
my @timings = split /\n/, read_file("$run/timings.tsv");
shift(@timings) eq "target\tresult\tseconds\tlog" or die "invalid timings header\n";
@timings == @required or die "incomplete validation timings\n";
my $events = "target\tstate\treason\n";
for (@{$plan->{stages}}) {
    $events .= join("\t", $_->{target}, $_->{required} ? 'blocked' : 'not-applicable', $_->{reason})."\n";
}
for my $i (0..$#required) {
    my ($target, $result, $seconds, $log) = split /\t/, $timings[$i], -1;
    $target eq $required[$i]{target} && $result eq 'PASS' && $seconds =~ /\A\d+\z/
        && defined($log) && $log =~ m{(?:\A|/)\Q$run\E/\Q$i\E\.log\z}
        or die "missing or failed required validation stage\n";
    regular("$run/$i.log");
    -f "$run/$i-before-inputs.json" && -f "$run/$i-after-inputs.json"
        or die "missing stage input observations\n";
    $events .= "$target\tPASS\t$log\n";
}
read_file("$run/plan-events.tsv") eq $events or die "failed, interrupted or changed validation events\n";
my @evidence = ($context_path, $plan_path, glob "$run/*");
my $proof = { schema => 1, source => $source, group => $group,
    files => {map { $_ => sha256_hex(read_file($_)) } @evidence} };
if ($operation eq 'seal') {
    write_document("$attempt/proof.json", $proof);
} else {
    same(document("$attempt/proof.json"), $proof, 'validation evidence changed or is missing');
}
