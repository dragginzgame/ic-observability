#!/usr/bin/env perl
use strict;
use warnings;
use Cwd qw(abs_path);
use File::Basename qw(dirname);
use File::Path qw(make_path);
use File::Copy qw(copy);
use File::Temp qw(tempdir);
use JSON::PP qw(decode_json);

# Check the current Cargo file selection in a package-shaped staging directory,
# so repository-only files cannot accidentally satisfy a published README link.
@ARGV == 0 or die "usage: check-package-doc-links.pl\n";
my $root = abs_path(dirname(__FILE__) . '/../..');
chdir $root or die "cannot enter checkout\n";
sub observe {
    open my $child, '-|', @_ or die "cannot start command\n";
    local $/;
    my $bytes = <$child> // '';
    close $child or die "package observation failed\n";
    return $bytes;
}
my $metadata = decode_json(observe(qw(cargo metadata --no-deps --locked --offline --format-version 1)));
make_path('target/qualification');
my $stage = tempdir('package-docs.XXXXXX', DIR => "$root/target/qualification", CLEANUP => 0);
print "Package documentation inputs retained: $stage\n";
my %members = map { $_ => 1 } @{$metadata->{workspace_members}};
for my $package (@{$metadata->{packages}}) {
    next unless $members{$package->{id}};
    my $directory = dirname($package->{manifest_path});
    my $files = observe('cargo', 'package', '-p', $package->{name}, qw(--list --locked --offline --allow-dirty));
    my $destination = "$stage/$package->{name}";
    my @documents;
    for my $path (split /\n/, $files) {
        $path !~ m{\A/|(?:\A|/)\.\.(?:/|\z)|[\r\0]} or die "invalid packaged path\n";
        my $source = "$directory/$path";
        next unless -f $source; # Cargo-owned generated manifest/lock/provenance.
        make_path(dirname("$destination/$path"));
        copy($source, "$destination/$path") or die "cannot stage packaged input\n";
        push @documents, $path if $path =~ /\.md\z/;
    }
    @documents or die "package has no selected documentation\n";
    system('perl', "$root/scripts/ci/check-documentation-links.pl", '--root', $destination, @documents) == 0
        or die "packaged documentation references failed for $package->{name}\n";
}
