#!/usr/bin/env perl
use strict;
use warnings;


# Resolved normal/build closures complement declaration admission. Development
# codec fixtures must not make Wire appear to be a production dependency.
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
    ['native-minimal', $host, 0, '--no-default-features'],
    ['native-recording', $host, 0, '--no-default-features', '--features', 'ic-metrics/recording'],
    ['native-default', $host, 1],
    ['wasm-all-features', 'wasm32-unknown-unknown', 0, '--all-features'],
);

for my $profile (@profiles) {
    my ($name, $target, $wire_expected, @features) = @$profile;
    for my $owner ('ic-metrics', 'ic-logging') {
        my @policy=$owner eq 'ic-logging'
            ? ('--forbid-pattern','^(?!ic-logging$)')
            : ('--require',"ic-wire=$wire_expected",'--require',"ic-wire-derive=$wire_expected",
               '--require','serde=1','--forbid-pattern','^(?:ic-platform(?:-.*)?|ic-wire-endpoint)$');
        my @selected_features = @features;
        @selected_features = ('--no-default-features') if $owner eq 'ic-logging' && $name eq 'native-recording';
        system($^X,'scripts/ci/check-cargo-graph.pl','--consumer','.',
            '--package',$owner,'--target',$target,'--edges','normal,build',@selected_features,@policy) == 0
            or die "$name: $owner production graph refused\n";
    }
    print "$name: resolved Metrics/Logging production graphs admitted\n";
}
