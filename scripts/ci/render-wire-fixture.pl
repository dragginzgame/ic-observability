#!/usr/bin/env perl
use strict;
use warnings;
use JSON::PP qw(decode_json encode_json);

# Render disposable Cargo inputs from parsed documents, never source line layout.
my ($root_file,$catalog_file,$destination,$mode,$metrics_file)=@ARGV;
defined($mode) && (($mode eq 'source' && @ARGV == 5) || ($mode eq 'published' && @ARGV == 4))
    or die "usage: render-wire-fixture.pl ROOT.json CATALOG.json DEST source METRICS.json | ROOT.json CATALOG.json DEST published\n";
sub read_json {
    open my $file,'<',shift or die "cannot read fixture input: $!\n";
    local $/; my $value=decode_json(<$file>); close $file or die "cannot close fixture input\n";
    ref($value) eq 'HASH' or die "expected a fixture table\n";
    return $value;
}
# JSON scalar spelling is also TOML scalar spelling. Cargo inputs contain no
# null/date values; nested tables use quoted keys and TOML inline-table syntax.
sub literal {
    my ($value)=@_;
    defined($value) or die "null is not a Cargo TOML value\n";
    return '{ '.join(', ',map { encode_json($_).' = '.literal($value->{$_}) } sort keys %$value).' }' if ref($value) eq 'HASH';
    return '['.join(', ',map { literal($_) } @$value).']' if ref($value) eq 'ARRAY';
    return encode_json($value);
}
sub write_manifest {
    my ($path,$document)=@_;
    my $text=join('',map { encode_json($_).' = '.literal($document->{$_})."\n" } sort keys %$document);
    open my $out,'>',$path or die "cannot write fixture manifest: $!\n";
    print {$out} $text or die "cannot render fixture manifest\n";
    close $out or die "cannot close fixture manifest\n";
}
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
