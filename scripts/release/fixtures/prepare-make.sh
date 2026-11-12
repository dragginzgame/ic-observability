# shellcheck shell=bash
# Consumer-specific setup for the two real Make-adapter fixtures.
prepare_make_fixture() {
    local source_root="$1" destination="$2" command
    unset OBSERVABILITY_RELEASE_VALIDATION_SCOPE OBSERVABILITY_RELEASE_VALIDATION_ATTEMPT
    mkdir -p "$destination/bin" "$destination/ci" "$destination/scripts/release"
    bash "$source_root/scripts/ci/prepare-script-fixture.sh" "$source_root" "$destination" \
        make/consumer.mk make/validation.mk make/cargo-dependencies.mk
    cp "$source_root/Makefile" "$destination/Makefile"
    cp "$source_root/ci/"{release-delivery.txt,cargo-release-groups.json,release-validation.json} "$destination/ci/"
    cp "$source_root/scripts/release/metadata.sh" "$destination/scripts/release/"
    # This fixture isolates Make routing. Direct deployment tooling admission
    # and refusal-before-effects are exercised by test-tooling-admission.sh.
    mkdir -p "$destination/scripts/dev"
    printf '#!/usr/bin/env bash\nexit 0\n' > "$destination/scripts/dev/toko-tooling.sh"
    printf 'print "Cleanup substituted for Make dispatch qualification.\\n";\n' > "$destination/scripts/dev/clean-empty-source-dirs.pl"
    # Compilation/admission semantics are tested separately; keep pipe propagation.
    cat > "$destination/scripts/ci/check-rust-compiler.sh" <<'COMPILER'
set -euo pipefail
if [[ "${REQUIRE_JOBSERVER:-0}" == 1 ]]; then perl "$JOBSERVER_PROBE"; fi
COMPILER
    cat > "$destination/scripts/ci/check-allocation-free.sh" <<'ALLOCATOR'
set -euo pipefail
if [[ "${REQUIRE_JOBSERVER:-0}" == 1 ]]; then perl "$JOBSERVER_PROBE"; fi
printf 'allocation-free-link\n' >> "$EVENTS"
ALLOCATOR
    STANDARD_RELEASE_REAL_BASH="$(command -v bash)"
    STANDARD_RELEASE_REAL_GIT="$(command -v git)"
    export STANDARD_RELEASE_REAL_BASH STANDARD_RELEASE_REAL_GIT
    export EVENTS="$destination/events" STANDARD_RELEASE_PHASE=real
    for command in bash cargo git; do
        printf '#!%s\n' "$STANDARD_RELEASE_REAL_BASH" > "$destination/bin/$command"
        cat "$source_root/scripts/release/fixtures/$command.sh" >> "$destination/bin/$command"
        chmod +x "$destination/bin/$command"
    done
    printf '#!%s\nexit 0\n' "$STANDARD_RELEASE_REAL_BASH" > "$destination/bin/rustc"
    chmod +x "$destination/bin/rustc"
    cat > "$destination/publication-metadata.json" <<'JSON'
{"version":1,"workspace_members":["metrics","logging"],"packages":[{"id":"metrics","name":"ic-metrics","version":"0.1.0","source":null,"publish":null},{"id":"logging","name":"ic-logging","version":"0.1.0","source":null,"publish":null}]}
JSON
}
