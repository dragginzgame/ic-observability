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
my $metadata = decode_json(observe(qw(cargo metadata --no-deps --locked --format-version 1)));
# Admit the complete roster before staging anything. An absent inventory is not
# evidence that there are no package documents to check.
ref($metadata) eq 'HASH' && JSON::PP->new->encode($metadata->{version}) eq '1'
    && ref($metadata->{workspace_members}) eq 'ARRAY' && @{$metadata->{workspace_members}}
    && ref($metadata->{packages}) eq 'ARRAY' && @{$metadata->{packages}}
    or die "invalid or empty Cargo package inventory\n";
sub identifier { defined($_[0]) && !ref($_[0]) && length($_[0]) && $_[0] !~ /[\x00-\x1f\x7f]/ }
my (%members, %packages, %names);
for my $id (@{$metadata->{workspace_members}}) {
    identifier($id) && !$members{$id}++ or die "invalid or duplicate Cargo member\n";
}
my @selected;
for my $package (@{$metadata->{packages}}) {
    ref($package) eq 'HASH' && identifier($package->{id}) && !$packages{$package->{id}}++
        or die "invalid or duplicate Cargo package\n";
    next unless $members{$package->{id}};
    identifier($package->{name}) && $package->{name} =~ /\A[A-Za-z0-9_-]+\z/
        && !$names{$package->{name}}++ && identifier($package->{manifest_path})
        && File::Spec->file_name_is_absolute($package->{manifest_path})
        or die "invalid Cargo member package fields\n";
    push @selected, $package;
}
@selected == keys(%members) or die "Cargo inventory omits a workspace member\n";
make_path('target/qualification');
my $stage = tempdir('package-docs.XXXXXX', DIR => "$root/target/qualification", CLEANUP => 0);
print "Package documentation inputs retained: $stage\n";
for my $package (@selected) {
    my $directory = dirname($package->{manifest_path});
    my $files = observe('cargo', 'package', '-p', $package->{name}, qw(--list --locked --allow-dirty));
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
