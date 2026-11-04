package CheckProcess;
use strict;
use warnings;
use Exporter 'import';
use IO::Select;
use POSIX qw(setsid dup2 WNOHANG _exit);
use Time::HiRes qw(clock_gettime CLOCK_MONOTONIC sleep);

our @EXPORT_OK = qw(observe);

# Read-only local check commands: bounded byte capture, no shell, owned process
# group and a monotonic deadline. Callers parse only a complete successful result.
sub observe {
    my $policy = ref($_[0]) eq 'HASH' ? shift : {};
    my @command = @_;
    my $limit = $policy->{max_stdout} // 4194304;
    my $error_limit = $policy->{max_stderr} // 1048576;
    my $seconds = $policy->{timeout} // 60;
    @command && $limit > 0 && $error_limit > 0 && $seconds > 0
        or die "invalid check process policy\n";
    my $interrupted = 0;
    local $SIG{INT} = sub { $interrupted = 1 };
    local $SIG{TERM} = sub { $interrupted = 1 };
    pipe(my $output, my $output_writer) or die "create stdout pipe: $!\n";
    pipe(my $errors, my $error_writer) or die "create stderr pipe: $!\n";
    my $pid = fork();
    defined($pid) or die "start check process: $!\n";
    if (!$pid) {
        $SIG{INT} = $SIG{TERM} = 'DEFAULT';
        close $output;
        close $errors;
        # Establish group ownership before exec can create descendants or output.
        setsid() >= 0 or _exit(126);
        open STDIN, '<', '/dev/null' or _exit(126);
        dup2(fileno($output_writer), 1) >= 0 or _exit(126);
        dup2(fileno($error_writer), 2) >= 0 or _exit(126);
        close $output_writer if fileno($output_writer) > 2;
        close $error_writer if fileno($error_writer) > 2;
        exec { $command[0] } @command or _exit(127);
    }
    close $output_writer;
    close $error_writer;
    my $selector = IO::Select->new($output, $errors);
    my ($stdout, $stderr, $reaped, $status) = ('', '', 0, 0);
    my $deadline = clock_gettime(CLOCK_MONOTONIC) + $seconds;
    my $failure = sub {
        return bless {kind => $_[0], command => \@command, status => $status, pid => $pid},
            'CheckProcess::Failure';
    };
    my $ok = eval {
        while (1) {
            !$interrupted or die $failure->('interrupted');
            my $remaining = $deadline - clock_gettime(CLOCK_MONOTONIC);
            $remaining > 0 or die $failure->('timeout');
            if (!$selector->count) {
                my $result = waitpid($pid, WNOHANG);
                if ($result == $pid) { $status = $?; $reaped = 1; last; }
                $result != -1 or die "wait for check process: $!\n";
                sleep($remaining < 0.01 ? $remaining : 0.01);
                next;
            }
            for my $stream ($selector->can_read($remaining < 0.1 ? $remaining : 0.1)) {
                my $count = sysread($stream, my $chunk, 65536);
                if (!defined($count)) { next if $!{EINTR}; die "read check process: $!\n"; }
                if (!$count) { $selector->remove($stream); next; }
                my $is_output = fileno($stream) == fileno($output);
                my $buffer = $is_output ? \$stdout : \$stderr;
                my $maximum = $is_output ? $limit : $error_limit;
                my $available = $maximum - length($$buffer);
                $$buffer .= substr($chunk, 0, $available);
                $count <= $available or die $failure->($is_output ? 'stdout-limit' : 'stderr-limit');
            }
        }
        $status == 0 or die $failure->('exit');
        # A successful leader must not leave a detached check worker behind.
        !kill(0, -$pid) or die $failure->('descendants');
        1;
    };
    my $error = $@;
    if (!$ok) {
        kill 'KILL', -$pid;
        if (!$reaped) {
            kill 'KILL', $pid; # Also handles cancellation before setsid completed.
            while (waitpid($pid, 0) == -1) { last unless $!{EINTR}; }
        }
    }
    close $output;
    close $errors;
    print STDERR $stderr if length $stderr;
    die $error unless $ok;
    return $stdout;
}

package CheckProcess::Failure;
use overload '""' => sub {
    my ($self) = @_;
    my $command = join ' ', @{$self->{command}};
    $command =~ s/([\x00-\x1f\x7f])/sprintf('\\x%02x', ord($1))/ge;
    return "failed observation: $command ($self->{kind}; wait status $self->{status})\n";
}, fallback => 1;

1;
