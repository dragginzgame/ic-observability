use strict;
use warnings;
use FindBin qw($RealBin);
use lib "$RealBin/..";
use CheckProcess qw(observe);
use File::Path qw(make_path);
use File::Temp qw(tempdir);
use JSON::PP qw(encode_json);
use Cwd qw(abs_path);
use Test::More;

my $root = abs_path("$RealBin/../../..");
make_path("$root/target/qualification");
my $fixture = tempdir('package-doc-inputs.XXXXXX', DIR => "$root/target/qualification", CLEANUP => 0);
note("Package input fixture retained: $fixture");
make_path("$fixture/scripts/ci", "$fixture/bin", "$fixture/package/src");
observe('bash', "$root/scripts/ci/prepare-script-fixture.sh", $root, $fixture,
    'scripts/ci/check-package-doc-links.pl', 'scripts/ci/check-documentation-links.pl');
sub write_file {
    open my $out, '>', $_[0] or die $!;
    print {$out} $_[1] or die $!;
    close $out or die $!;
}
write_file("$fixture/metadata.json", encode_json({workspace_members => ['fixture'], packages => [{
    id => 'fixture', name => 'fixture', manifest_path => "$fixture/package/Cargo.toml",
}]}));
write_file("$fixture/package/Cargo.toml", "[package]\n");
write_file("$fixture/package/README.md", "Fixture documentation.\n");
write_file("$fixture/package/src/lib.rs", "// maintained\n");
write_file("$fixture/bin/cargo", <<'CARGO');
#!/usr/bin/env bash
set -euo pipefail
case "$1" in
    metadata) cat "$DOC_INPUT_FIXTURE/metadata.json" ;;
    package) cat "$DOC_INPUT_FIXTURE/roster" ;;
    *) exit 99 ;;
esac
CARGO
chmod 0755, "$fixture/bin/cargo" or die $!;
local $ENV{DOC_INPUT_FIXTURE} = $fixture;
local $ENV{PATH} = "$fixture/bin:$ENV{PATH}";
my $roster = "Cargo.toml\nCargo.toml.orig\nCargo.lock\n.cargo_vcs_info.json\nREADME.md\nsrc/lib.rs\n";
for my $case ('valid', 'missing', 'symlink', 'directory') {
    my $selected = $roster;
    if ($case ne 'valid') {
        $selected .= "src/required.rs\n";
        symlink 'lib.rs', "$fixture/package/src/required.rs" or die $! if $case eq 'symlink';
        mkdir "$fixture/package/src/required.rs" or die $! if $case eq 'directory';
    }
    write_file("$fixture/roster", $selected);
    my $accepted = eval { observe($^X, "$fixture/scripts/ci/check-package-doc-links.pl"); 1 };
    if ($case eq 'valid') { ok($accepted, 'maintained files and known Cargo-generated absences are admitted'); }
    else { ok(!$accepted, "$case maintained input refuses"); }
    unlink "$fixture/package/src/required.rs" if $case eq 'symlink';
    rmdir "$fixture/package/src/required.rs" if $case eq 'directory';
}
write_file("$fixture/metadata.json", encode_json({workspace_members => ['fixture'], packages => [{
    id => 'fixture', name => 'fixture', manifest_path => "$fixture/package/Cargo.toml",
    license_file => '../LICENSE.md',
}]}));
write_file("$fixture/LICENSE.md", "Fixture distribution notice.\n");
write_file("$fixture/roster", $roster . "LICENSE.md\n");
ok(eval { observe($^X, "$fixture/scripts/ci/check-package-doc-links.pl"); 1 },
    'Cargo root-licence copy is staged from its canonical source');
unlink "$fixture/LICENSE.md" or die $!;
ok(!eval { observe($^X, "$fixture/scripts/ci/check-package-doc-links.pl"); 1 },
    'missing canonical root licence refuses');
done_testing();
