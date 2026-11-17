#!/usr/bin/env perl
use strict;
use warnings;
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
my @secrets=map {split /\n/,$ENV{$_}} grep {
    /(?:TOKEN|SECRET|PASSWORD|PRIVATE_KEY|CREDENTIAL|ACCESS_KEY|AUTHORIZATION)/i
        && defined($ENV{$_}) && length($ENV{$_})>=4
} keys %ENV;
@secrets=grep {length($_)>=4} @secrets;
my ($tail,$pending,$seen,$omitted,$oversized,$key)=('', '',0,0,0,0);
sub retain_line {
    my ($line)=@_;
    $line =~ s/\e\[[0-?]*[ -\/]*[\@-~]//g;
    $line =~ s/[\x00-\x08\x0b-\x1f\x7f]//g;
    if ($line =~ /-----BEGIN .*PRIVATE KEY-----/) {$key=1; $line="[private key omitted]\n";}
    elsif ($key) {$key=0 if $line =~ /-----END .*PRIVATE KEY-----/; return;}
    for my $secret (@secrets) {$line =~ s/\Q$secret\E/[REDACTED]/g;}
    $line="[sensitive field or environment assignment omitted]\n"
        if $line =~ /(?:token|secret|password|credential|authorization|private[_ -]?key|access[_ -]?key)\s*["']?\s*[:=]/i
        || $line =~ /\A[A-Za-z_][A-Za-z0-9_]*=/;
    $line =~ s{(https?://)[^/\s]*\@}{${1}[REDACTED]\@}g;
    $line =~ s/\b(?:gh[pousr]_[A-Za-z0-9_]+|github_pat_[A-Za-z0-9_]+)\b/[REDACTED]/g;
    $line="[encoded payload omitted]\n" if $line =~ /\A[A-Za-z0-9+\/=]{40,}\s*\z/;
    $tail.=$line;
    while(length($tail)>$limit-128) {$tail =~ s/\A[^\n]*\n// or $tail=''; $omitted=1;}
}
my $pid=open my $pipe,'-|'; defined($pid) or die "start setup command: $!\n";
if (!$pid) {open STDERR,'>&',STDOUT or die $!; exec {$command[0]} @command; die "exec setup command: $!\n";}
while (1) {
    my $n=sysread($pipe,my $chunk,4096); defined($n) or die "read setup output: $!\n"; last unless $n;
    $seen+=$n; $pending.=$chunk;
    while($pending =~ s/\A([^\n]*\n)//) {
        my $line=$1;
        if($oversized || length($line)>4096) {retain_line("[oversized line omitted]\n");$omitted=1;$oversized=0;}
        else {retain_line($line);}
    }
    if(length($pending)>4096) {$pending='';$oversized=1;$omitted=1;}
}
retain_line($oversized ? "[oversized line omitted]\n" : "$pending\n") if length($pending) || $oversized;
close $pipe;
my $status=$? == -1 ? 127 : ($? & 127) ? 128+($? & 127) : $? >> 8;
my $log="$root/.setup/$phase.log";
my $metadata={phase=>$phase,tool=>$command[0],status=>$status,bytes_seen=>$seen,
    truncated=>$omitted ? JSON::PP::true : JSON::PP::false,log=>$log};
my $saved=eval {
    my $diagnostic=($omitted ? "[output truncated; retained tail]\n" : '').($tail || "[no diagnostics emitted]\n");
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
print "[diagnostic excerpt truncated]\n" if length($tail)>4096 || $omitted;
print length($excerpt) ? $excerpt : "[no diagnostics emitted]\n";
if (!$saved) {print STDERR "Setup evidence collection failed: $@"; $status ||= 2;}
exit $status;
