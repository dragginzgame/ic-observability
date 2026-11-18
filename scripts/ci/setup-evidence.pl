#!/usr/bin/env perl
# Shared companions: vendor/toko-tooling/scripts/ci/SetupDiagnostics.pm
use strict;
use warnings;
use FindBin qw($RealBin);
use lib "$RealBin/../../vendor/toko-tooling/scripts/ci";
use SetupDiagnostics qw(excerpt);
use Fcntl qw(:DEFAULT :mode);
use File::Path qw(make_path);
use File::Temp qw(tempdir);
use JSON::PP;
use Digest::SHA ();

# Consumer CI owns this small, explicitly selected setup diagnostic boundary.
# Raw process output never enters either the Actions log or an uploaded archive.
umask 0077;
my $collect=(@ARGV && $ARGV[0] eq '--collect') ? shift(@ARGV) : '';
my ($root,$phase,@command)=@ARGV;
defined($root) && $root =~ m{\Atarget/evidence/[a-z0-9-]+\z}
    or die "select a repository-local evidence directory\n";
my $parent='';
for my $part (split m{/},$root) {
    $parent=length($parent) ? "$parent/$part" : $part;
    -l $parent and die "setup evidence traverses a symlink\n";
}
make_path("$root/.setup");
-l "$root/.setup" and die "setup evidence directory is a symlink\n";
my $limit=64*1024;
sub write_new {
    my ($path,$bytes)=@_;
    sysopen my $fh,$path,O_WRONLY|O_CREAT|O_EXCL,0600 or die "create setup evidence: $!\n";
    print {$fh} $bytes or die "write setup evidence: $!\n";
    close $fh or die "close setup evidence: $!\n";
}
if ($collect) {
    @command==0 && defined($phase) && $phase =~ m{\Atarget/evidence/[a-z0-9-]+\.tar\.gz\z}
        or die "usage: setup-evidence.pl --collect ROOT NEW-ARCHIVE\n";
    my $stage=tempdir('sanitized.XXXXXX',DIR=>$root,CLEANUP=>0);
    make_path("$stage/.setup");
    opendir my $dir,"$root/.setup" or die "read setup evidence: $!\n";
    my @names=sort grep {/\A[a-z0-9-]+\.(?:log|json)\z/} readdir $dir;
    closedir $dir;
    @names && @names<=32 or die "setup diagnostics missing or over the 32-file limit\n";
    my %selected=map {$_=>1} @names;
    for my $name (@names) {
        (my $pair=$name) =~ s/\.(log|json)\z/$1 eq 'log' ? '.json' : '.log'/e;
        $selected{$pair} or die "paired setup diagnostic is missing\n";
    }
    my $total=0;
    for my $name (@names) {
        my $path="$root/.setup/$name";
        sysopen my $fh,$path,O_RDONLY|O_NOFOLLOW|O_NONBLOCK or die "open selected setup evidence: $!\n";
        my @s=stat $fh;
        S_ISREG($s[2]) && $s[7]<=$limit or die "invalid or oversized setup evidence\n";
        my $n=read($fh,my $bytes,$limit+1); close $fh;
        defined($n) && $n<=$limit or die "setup diagnostic changed or exceeded its bound\n";
        $total+=length($bytes); $total<=1024*1024 or die "setup diagnostics exceed 1 MiB\n";
        write_new("$stage/.setup/$name",$bytes);
    }
    # Archive only admitted sanitized files, including the explicit hidden roster.
    sysopen my $archive,$phase,O_WRONLY|O_CREAT|O_EXCL,0600 or die "create setup archive: $!\n";
    my $pid=fork(); defined($pid) or die "fork archive: $!\n";
    if (!$pid) {open STDOUT,'>&',$archive or die $!; exec 'tar','-czf','-','-C',$stage,'.setup'; die "exec tar: $!\n";}
    close $archive; waitpid($pid,0); $?==0 or die "setup diagnostic archive failed (status $?)\n";
    open my $fh,'<',$phase or die $!; binmode $fh;
    my $digest=Digest::SHA->new(256)->addfile($fh)->hexdigest; close $fh;
    write_new("$phase.sha256","$digest\n");
    print "Sanitized setup diagnostics: $phase ($total bytes before compression)\n";
    exit;
}
defined($phase) && $phase =~ /\A[a-z0-9-]+\z/ && @command
    or die "usage: setup-evidence.pl ROOT PHASE COMMAND [ARG...]\n";
my $pid=open my $pipe,'-|'; defined($pid) or die "start setup command: $!\n";
if (!$pid) {open STDERR,'>&',STDOUT or die $!; exec {$command[0]} @command; die "exec setup command: $!\n";}
my $tail=eval {
    # Preserve this adapter's existing environment-secret coverage, including
    # multiline values and authorization/access-key names. Shared recognizes
    # SECRET aliases; these local aliases never enter the already-forked command.
    my @values=map {split /\n/,$ENV{$_}} grep {
        /TOKEN|SECRET|PASSWORD|PRIVATE_KEY|CREDENTIAL|ACCESS_KEY|AUTHORIZATION/i
            && defined($ENV{$_})
    } keys %ENV;
    local %ENV=%ENV;
    my $index=0;
    for my $value (@values) { $ENV{'OBSERVABILITY_SECRET_' . $index++}=$value if length($value)>=4; }
    excerpt($pipe);
};
close $pipe;
my $status=$? == -1 ? 127 : ($? & 127) ? 128+($? & 127) : $? >> 8;
if (!defined $tail) { $tail="[setup output collection failed]\n"; $status ||= 2; }
my $log="$root/.setup/$phase.log";
# Shared owns stream redaction and retention; report retained bytes, not an
# invented raw-byte count or completeness claim about the original stream.
my $metadata={phase=>$phase,tool=>$command[0],status=>$status,retained_bytes=>length($tail),
    bounded=>JSON::PP::true,log=>$log};
my $saved=eval {
    my $diagnostic=$tail;
    write_new($log,$diagnostic);
    write_new("$root/.setup/$phase.json",JSON::PP->new->canonical->encode($metadata)."\n");
    my %legacy=('setup-smoke'=>'setup-smoke.log','host-tools'=>'host-tools.log',
        compiler=>'compiler.txt',tools=>'tools-setup.log','tool-inputs'=>'tool-versions.txt',
        'application-sources'=>'application-sources.log');
    write_new("$root/$legacy{$phase}",$diagnostic) if exists $legacy{$phase};
    1;
};
print "CI setup phase=$phase tool=$command[0] status=$status evidence=$log\n";
my $excerpt=substr($tail,-4096); $excerpt =~ s/\A[^\n]*\n// if length($tail)>4096;
print "[diagnostic excerpt truncated]\n" if length($tail)>4096;
print length($excerpt) ? $excerpt : "[no diagnostics emitted]\n";
if (!$saved) {print STDERR "Setup evidence collection failed: $@"; $status ||= 2;}
exit $status;
