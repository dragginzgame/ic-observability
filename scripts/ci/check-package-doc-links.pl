#!/usr/bin/env perl
# Shared companions: scripts/ci/CheckProcess.pm
use strict;
use warnings;
use Cwd qw(abs_path);
use File::Basename qw(dirname);
use File::Path qw(make_path);
use File::Copy qw(copy);
use File::Spec;
use File::Temp qw(tempdir);
use JSON::PP qw(decode_json);
use FindBin qw($RealBin);
use lib $RealBin;
use CheckProcess qw(observe);

# Check the current Cargo file selection in a package-shaped staging directory,
# so repository-only files cannot accidentally satisfy a published README link.
@ARGV == 0 or die "usage: check-package-doc-links.pl\n";
my $root = abs_path(dirname(__FILE__) . '/../..');
chdir $root or die "cannot enter checkout\n";
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
        if ($path eq 'LICENSE.md') {
            my $licence = abs_path(File::Spec->rel2abs($package->{license_file} // '', $directory));
            defined($licence) && $licence eq "$root/LICENSE.md" && !-l "$root/LICENSE.md"
                or die "package does not select the canonical root licence\n";
            $source = $licence;
        }
        if (!-e $source && !-l $source) {
            # Only Cargo's generated lock, original-manifest and provenance
            # entries may lack a maintained source file.
            next if $path =~ /\A(?:Cargo\.lock|Cargo\.toml\.orig|\.cargo_vcs_info\.json)\z/;
            die "missing maintained packaged input: $path\n";
        }
        -f $source && !-l $source or die "non-regular packaged input: $path\n";
        make_path(dirname("$destination/$path"));
        copy($source, "$destination/$path") or die "cannot stage packaged input\n";
        push @documents, $path if $path =~ /\.md\z/;
    }
    @documents or die "package has no selected documentation\n";
    system('perl', "$root/vendor/toko-tooling/scripts/ci/check-documentation-links.pl", '--root', $destination, @documents) == 0
        or die "packaged documentation references failed for $package->{name}\n";
}
