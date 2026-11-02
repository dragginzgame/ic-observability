#!/usr/bin/env perl
use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../ci";
use FixtureManifest qw(read_json write_manifest);
use JSON::PP ();

my ($root_file,$destination,$supplier,$version)=@ARGV;
@ARGV == 4 && $supplier =~ /\A(?:metrics|logging)\z/
    or die "usage: render-retained-consumer.pl ROOT.json DEST.toml metrics|logging VERSION\n";
my $root=read_json($root_file);
my $workspace=$root->{workspace};
ref($workspace) eq 'HASH' && ref($workspace->{dependencies}) eq 'HASH'
    or die "missing workspace catalog\n";
$workspace->{members}=['supplier','client'];
$workspace->{'default-members'}=['client'];
my $dependencies=$workspace->{dependencies};
delete @{$dependencies}{'ic-metrics','ic-logging'};
# Unlike a source-identity probe, this client retains the supplier's real version.
$dependencies->{"ic-$supplier"}={
    path => 'supplier', version => "=$version", 'default-features' => JSON::PP::false,
};
write_manifest($destination,$root);
