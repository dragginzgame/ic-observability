#!/usr/bin/env perl
use strict;
use warnings;
use FindBin qw($Bin);
use lib $Bin;
use FixtureManifest qw(read_json write_manifest);
use JSON::PP ();

# Render disposable Cargo inputs from parsed documents, never source line layout.
my ($root_file,$catalog_file,$destination,$mode,$metrics_file)=@ARGV;
defined($mode) && (($mode eq 'source' && @ARGV == 5) || ($mode eq 'published' && @ARGV == 4))
    or die "usage: render-wire-fixture.pl ROOT.json CATALOG.json DEST source METRICS.json | ROOT.json CATALOG.json DEST published\n";
my $root=read_json($root_file);
my $catalog=read_json($catalog_file);
my $workspace=$root->{workspace};
ref($workspace) eq 'HASH' && ref($workspace->{dependencies}) eq 'HASH' or die "missing workspace catalog\n";
$workspace->{members}=$mode eq 'source' ? ['crates/ic-metrics','probe'] : ['probe'];
$workspace->{'default-members'}=['probe'];
my $dependencies=$workspace->{dependencies};
delete $dependencies->{'ic-logging'};
if ($mode eq 'source') {
    for my $name (keys %$catalog) {
        !exists($dependencies->{$name}) or die "source catalog overlaps the workspace dependency owner: $name\n";
        $dependencies->{$name}=$catalog->{$name};
    }
    $dependencies->{'ic-metrics'}{version}='0.0.0';
    $dependencies->{'ic-metrics'}{'default-features'}=JSON::PP::false;
    my $metrics=read_json($metrics_file);
    $metrics->{package}{version}='0.0.0';
    write_manifest("$destination/crates/ic-metrics/Cargo.toml",$metrics);
} else {
    delete $dependencies->{'ic-wire'};
    for my $name (keys %$catalog) { $dependencies->{$name}=$catalog->{$name}; }
}
write_manifest("$destination/Cargo.toml",$root);
