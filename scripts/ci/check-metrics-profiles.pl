#!/usr/bin/env perl
use strict;
use warnings;


# Resolved normal/build closures complement declaration admission. Development
# dependencies must not enter the measurement production graph.
@ARGV == 0 or die "usage: check-metrics-profiles.pl\n";
$ENV{RUSTUP_AUTO_INSTALL} = '0';

sub observe {
    my (@command) = @_;
    open my $child, '-|', @command or die "cannot start $command[0]: $!\n";
    local $/;
    my $output = <$child> // '';
    close $child or die "failed observation: @command\n";
    return $output;
}

my ($host) = observe(qw(rustc -vV)) =~ /^host: (\S+)$/m;
defined($host) or die "missing compiler host triple\n";
my @profiles = (
    ['native-minimal', $host, '--no-default-features'],
    ['native-recording', $host, '--no-default-features', '--features', 'ic-metrics/recording'],
    ['native-default', $host],
    ['wasm-all-features', 'wasm32-unknown-unknown', '--all-features'],
);

for my $profile (@profiles) {
    my ($name, $target, @features) = @$profile;
    system($^X,'scripts/ci/check-cargo-graph.pl','--consumer','.',
        '--package','ic-metrics','--target',$target,'--edges','normal,build',@features,
        '--require','serde=1','--forbid-pattern','^(?:ic-wire(?:-.*)?|ic-platform(?:-.*)?)$') == 0
        or die "$name: ic-metrics production graph refused\n";
    print "$name: resolved Metrics production graph admitted\n";
}

# Logging has no feature matrix. Declaration admission independently refuses
# every dependency; observe its resolved closure once per supported target.
for my $target ($host, 'wasm32-unknown-unknown') {
    system($^X,'scripts/ci/check-cargo-graph.pl','--consumer','.',
        '--package','ic-logging','--target',$target,'--edges','normal,build',
        '--all-features','--forbid-pattern','^(?!ic-logging$)') == 0
        or die "$target: ic-logging production graph refused\n";
    print "$target: dependency-free Logging production graph admitted\n";
}
