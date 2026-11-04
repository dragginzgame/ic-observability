use strict;
use warnings;
use FindBin qw($RealBin);
use lib "$RealBin/..";
use CheckProcess qw(observe);
use POSIX qw(WNOHANG);
use Test::More;

is(observe($^X, '-e', 'print "bytes\0\xff"'), "bytes\0\xff", 'complete bytes are unchanged');
is(observe({max_stdout => 4}, $^X, '-e', 'print "1234"'), '1234', 'exact byte cap is admitted');
my $diagnostic = '';
{
    local *STDERR;
    open STDERR, '>', \$diagnostic or die $!;
    is(observe($^X, '-e', 'print STDERR "diagnostic"; print "result"'), 'result', 'streams stay separate');
}
is($diagnostic, 'diagnostic', 'complete bounded diagnostics are replayed');

for my $case (
    ['stdout-limit', {max_stdout => 8}, 'print "x" x 65536; sleep 30'],
    ['stderr-limit', {max_stderr => 8}, 'print STDERR "x" x 65536; sleep 30'],
    ['exit', {}, 'print "partial"; exit 7'],
    ['timeout', {timeout => 0.3}, 'sleep 30'],
    ['timeout', {timeout => 0.3}, 'close STDOUT; close STDERR; sleep 30'],
    ['timeout', {timeout => 0.3}, 'if (fork() == 0) { sleep 30; exit } exit'],
    ['interrupted', {}, 'kill "TERM", getppid(); sleep 30'],
) {
    my ($kind, $policy, $source) = @$case;
    my ($error, $replayed) = ('', '');
    {
        local *STDERR;
        open STDERR, '>', \$replayed or die $!;
        eval { observe($policy, $^X, '-e', $source); 1 } or $error = $@;
    }
    isa_ok($error, 'CheckProcess::Failure');
    is($error->{kind}, $kind, 'failure retains its structured category');
    is(waitpid($error->{pid}, WNOHANG), -1, 'owned child is already reaped');
    is($error->{status}, 7 << 8, 'child failure status is retained') if $kind eq 'exit';
    is(length $replayed, 8, 'excess diagnostics are bounded') if $kind eq 'stderr-limit';
}
done_testing();
