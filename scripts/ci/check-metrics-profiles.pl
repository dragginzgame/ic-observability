#!/usr/bin/env perl
# Shared companions: scripts/ci/CheckProcess.pm
use strict;
use warnings;
use FindBin qw($RealBin);
use lib $RealBin;
use CheckProcess qw(observe);

# Resolved normal/build closures complement declaration admission. Development
# dependencies must not enter the measurement production graph.
my $group = shift // 'all';
@ARGV == 0 && $group =~ /\A(?:all|metrics|logging)\z/
    or die "usage: check-metrics-profiles.pl [metrics|logging]\n";
$ENV{RUSTUP_AUTO_INSTALL} = '0';

my ($host) = observe(qw(rustc -vV)) =~ /^host: (\S+)$/m;
defined($host) or die "missing compiler host triple\n";
my @profiles = (
    ['native-minimal', $host, '--no-default-features'],
    ['native-recording', $host, '--no-default-features', '--features', 'ic-metrics/recording'],
    ['native-default', $host],
    ['wasm-all-features', 'wasm32-unknown-unknown', '--all-features'],
);

for my $profile ($group eq 'logging' ? () : @profiles) {
    my ($name, $target, @features) = @$profile;
    system($^X,'vendor/toko-tooling/scripts/ci/check-cargo-graph.pl','--consumer','.',
        '--package','ic-metrics','--target',$target,'--edges','normal,build',@features,
        '--forbid-pattern','^(?!ic-metrics$)') == 0
        or die "$name: ic-metrics production graph refused\n";
    print "$name: resolved Metrics production graph admitted\n";
}

# Logging has no feature matrix. Declaration admission independently refuses
# every dependency; observe its resolved closure once per supported target.
for my $target ($group eq 'metrics' ? () : ($host, 'wasm32-unknown-unknown')) {
    system($^X,'vendor/toko-tooling/scripts/ci/check-cargo-graph.pl','--consumer','.',
        '--package','ic-logging','--target',$target,'--edges','normal,build',
        '--all-features','--forbid-pattern','^(?!ic-logging$)') == 0
        or die "$target: ic-logging production graph refused\n";
    print "$target: dependency-free Logging production graph admitted\n";
}
