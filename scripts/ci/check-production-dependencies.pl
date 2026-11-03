#!/usr/bin/env perl
use strict;
use warnings;
use Cwd qw(getcwd);
use JSON::PP qw(decode_json);

# Observability owns per-package declaration admission and transport boundaries.
# This check never installs tools, builds artifacts or changes the locked graph.
if (@ARGV) {
    @ARGV == 2 && shift(@ARGV) eq '--consumer'
        or die "usage: check-production-dependencies.pl [--consumer ROOT]\n";
    my $directory = shift @ARGV;
    $directory !~ /[\r\n]/ or die "consumer path contains CR/LF\n";
    chdir $directory or die "cannot enter consumer: $!\n";
}
getcwd() !~ /[\r\n]/ or die "resolved consumer path contains CR/LF\n";
$ENV{RUSTUP_AUTO_INSTALL} = '0';

sub observe {
    my (@command) = @_;
    open my $child, '-|', @command or die "cannot start $command[0]: $!\n";
    local $/;
    my $bytes = <$child> // '';
    close $child or die "failed observation: @command\n";
    return $bytes;
}

my $bytes = observe(qw(cargo metadata --no-deps --locked --offline --format-version 1));
my $metadata = eval { decode_json($bytes) };
$@ and die "invalid Cargo workspace metadata\n";
ref($metadata) eq 'HASH' && ($metadata->{version} // 0) == 1
    && ref($metadata->{workspace_members}) eq 'ARRAY'
    && ref($metadata->{packages}) eq 'ARRAY'
    or die "invalid Cargo workspace metadata\n";
my %members = map { $_ => 1 } @{$metadata->{workspace_members}};
my %owners = ('ic-metrics' => 'measurement', 'ic-logging' => 'logging');
my %packages;
my %observed_members;
for my $package (@{$metadata->{packages}}) {
    next unless $members{$package->{id}};
    my $name = $package->{name};
    exists($owners{$name}) && !$packages{$name}++ && !$observed_members{$package->{id}}++
        or die "unclassified production workspace package: $name\n";
    ref($package->{dependencies}) eq 'ARRAY' or die "missing declared dependencies\n";
    my $features = $package->{features};
    ref($features) eq 'HASH' or die "missing declared features\n";
    @{$features->{default} // []} == 0
        or die "$name has unapproved default features\n";
    !exists($features->{'native-wire'})
        or die "$name declares the retired native-wire feature\n";
    for my $dependency (@{$package->{dependencies}}) {
        $dependency->{name} !~ /\Aic-wire(?:-|\z)/
            or die "$name directly depends on Wire: $dependency->{name}\n";
        # Metadata includes inactive optional and target-specific declarations.
        if (($dependency->{kind} // 'normal') ne 'dev') {
            die "$name declares a production dependency: $dependency->{name}\n";
        }
        # Development dependencies must not bypass the governed Storage facade.
        $dependency->{name} ne 'ic-stable-structures'
            or die "$name directly depends on the stable substrate\n";
    }
    # Local switches may compose one another, never widen dependency features.
    for my $feature (keys %$features) {
        my $edges = $features->{$feature};
        ref($edges) eq 'ARRAY' or die "invalid declared features\n";
        for my $edge (@$edges) {
            defined($edge) && !ref($edge) && exists($features->{$edge})
                or die "$name forwards dependency features\n";
        }
    }
}
for my $name (keys %owners) {
    $packages{$name} or die "missing registered workspace package: $name\n";
}
for my $member (keys %members) {
    $observed_members{$member} or die "missing workspace member metadata\n";
}
print "Dependency-free Metrics and independent Logging declarations admitted.\n";
