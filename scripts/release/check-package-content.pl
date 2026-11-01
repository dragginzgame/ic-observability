#!/usr/bin/env perl
use strict;
use warnings;

# Consumer policy: every maintained package file must match the retrieved Git
# source. Cargo-generated manifest, lock and provenance have separate owners.
@ARGV == 5 or die "usage: check-package-content.pl ARCHIVE SOURCE_GIT COMMIT PACKAGE\@VERSION PACKAGE_PATH\n";
my ($archive, $git, $commit, $selection, $path) = @ARGV;
for ($archive, $git) { /[\r\n]/ and die "invalid content observation path\n"; }
$selection =~ /\A(ic-(?:metrics|logging))\@([0-9]+\.[0-9]+\.[0-9]+)\z/ or die "invalid package selection\n";
my $prefix = "$1-$2/";
$commit =~ /\A[0-9a-f]{40,64}\z/ or die "invalid source commit\n";
$path =~ m{\Acrates/ic-(?:metrics|logging)\z} or die "invalid package path\n";

sub observe {
    open my $child, '-|', @_ or die "cannot start content observation\n";
    binmode $child;
    my $output = '';
    while (1) {
        my $count = read($child, my $chunk, 65536);
        defined($count) or die "cannot read content observation\n";
        last unless $count;
        $output .= $chunk;
        length($output) <= 33554432 or die "content observation exceeds 32 MiB\n";
    }
    close $child or die "content observation failed\n";
    return $output;
}

my %expected;
for my $record (split /\0/, observe('git', '--git-dir', $git, 'ls-tree', '-rz', $commit, '--', "$path/")) {
    $record =~ /\A(100644|100755) blob ([0-9a-f]+)\t\Q$path\E\/(.+)\z/s
        or die "package source contains a non-regular file\n";
    my ($object, $name) = ($2, $3);
    $expected{$name eq 'Cargo.toml' ? 'Cargo.toml.orig' : $name} = $object;
}
keys(%expected) && exists($expected{'Cargo.toml.orig'}) or die "missing maintained package source\n";
my @names = split /\n/, observe('tar', '-tzf', $archive);
my @details = split /\n/, observe('tar', '-tzvf', $archive);
@names == @details or die "inconsistent archive roster\n";
my %directories = ('' => 1);
for my $name (keys %expected) {
    while ($name =~ s{/[^/]+\z}{}) { $directories{$name} = 1; }
}
my (%seen, %files);
for my $index (0 .. $#names) {
    my $name = $names[$index];
    $name =~ m{\A\Q$prefix\E([A-Za-z0-9_./-]*)\z} or die "unexpected archive path\n";
    my $relative = $1;
    $relative !~ m{(?:\A|/)\.\.?(/|\z)|//} or die "noncanonical archive path\n";
    !$seen{$name}++ or die "duplicate archive member\n";
    my $kind = substr($details[$index], 0, 1);
    $kind eq '-' || $kind eq 'd' or die "non-regular archive member\n";
    if ($kind eq 'd') {
        $relative =~ s{/\z}{};
        exists($directories{$relative}) or die "unexpected archive directory\n";
        next;
    }
    length($relative) or die "empty archive filename\n";
    $files{$relative} = $name;
}
for my $generated ('Cargo.toml', 'Cargo.lock', '.cargo_vcs_info.json') {
    exists($files{$generated}) or die "missing Cargo-generated member\n";
    delete $files{$generated};
}
join("\0", sort keys %files) eq join("\0", sort keys %expected)
    or die "maintained package roster differs from source\n";
for my $name (sort keys %expected) {
    observe('tar', '-xzOf', $archive, $files{$name}) eq
        observe('git', '--git-dir', $git, 'cat-file', 'blob', $expected{$name})
        or die "package content differs from source: $name\n";
}
printf "Maintained package content verified: %s (%d files)\n", $selection, scalar keys %expected;
