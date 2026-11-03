#!/usr/bin/env perl
use strict;
use warnings;
use JSON::PP qw(decode_json encode_json);

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
# Retain the supplier's real version; this client must not normalize identity.
$dependencies->{"ic-$supplier"}={
    path => 'supplier', version => "=$version", 'default-features' => JSON::PP::false,
};
write_manifest($destination,$root);
