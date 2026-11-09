.DEFAULT_GOAL := help

PACKAGE := ic-metrics
export RELEASE_GROUP
export RELEASE_DELIVERY ?= direct
export YQ := $(CURDIR)/.tools/host/bin/yq
LOCAL_TOOL_INSTALL_TARGETS := install-release-editor
LOCAL_TOOL_CHECK_TARGETS := release-editor-check
# Normal setup needs host/Cargo tools only; optional IC tools are selected explicitly.
IC_TOOLS :=
# Retained consumer contracts are copied into generated workspaces for execution.
FORMAT_RUST_ARGS := --rustfmt-edition 2024 \
	--rustfmt-source scripts/release/fixtures/retained-consumer/tests/metrics.rs \
	--rustfmt-source scripts/release/fixtures/retained-consumer/tests/logging.rs
# Load the shared publication adapter directly; resolve eligibility only after
# the public target's group prerequisite, never while parsing unrelated checks.
override CARGO_PUBLISH_PACKAGES :=
publish publish-check: override CARGO_PUBLISH_PACKAGES = $(shell RELEASE_GROUP='$(subst ','"'"',$(RELEASE_GROUP))' bash scripts/release/metadata.sh packages)
CARGO_PUBLISH_REGISTRY := crates-io
CARGO_PUBLISH_VERIFY_TARGETS := publication-source-check clippy
export OBSERVABILITY_PUBLICATION_MODE
publish: override OBSERVABILITY_PUBLICATION_MODE := publish
publish-check: override OBSERVABILITY_PUBLICATION_MODE := check
# Publication admits and lints only the explicitly selected independent group.
export OBSERVABILITY_RELEASE_VALIDATION_SCOPE
publish publish-check: override OBSERVABILITY_RELEASE_VALIDATION_SCOPE := group

# Common commands use this checkout's reviewed snapshot, including scratch exports.
override TOKO_TOOLING_ROOT := $(CURDIR)
export TOKO_TOOLING_ROOT
override RELEASE_DELIVERY_POLICY := $(CURDIR)/ci/release-delivery.txt
include make/consumer.mk
include make/cargo-publication.mk

# These consumer-owned gates retain execution/failure admission now that the
# common guard runs only for protected recipes. Help and completion remain inert.
ci compiler-check check check-wasm clippy docs-check test package-check allocation-free-check \
release-verify release-prepare-version release-commit-check release-prepared-check \
release-committed-check release-tagged-check release-push-check: | toko-execution-check

# Shared owns capture/default selection; this consumer owns candidate preparation.
export RELEASE_GROUPS
override RELEASE_SETUP_TARGET := release-candidate-setup

.PHONY: $(SHARED_RELEASE_TARGETS)

.PHONY: release-group-check
$(SHARED_RELEASE_TARGETS) release-batch-resume publish publish-check: | release-group-check
release-group-check:
	@bash scripts/release/metadata.sh selection

# Reject a missing/unknown group before Cargo-based tooling admission. Routine
# CI and explicit tooling checks remain independent of release selection.
ifneq ($(filter $(SHARED_RELEASE_TARGETS) release-batch-resume publish publish-check,$(MAKECMDGOALS)),)
toko-tooling-check clean-empty-source-dirs: | release-group-check
endif

# Captured recovery can bypass the common increment/preflight entrypoints.
release-batch-resume: toko-tooling-check

.PHONY: release-candidate-setup
release-candidate-setup:
	+@RELEASE_MAKE="$(MAKE_COMMAND)" HOST_TOOL_VERSIONS="$(HOST_TOOL_VERSIONS)" RUST_TOOL_VERSIONS="$(RUST_TOOL_VERSIONS)" bash scripts/release/candidate-setup.sh

ifeq ($(RELEASE_BATCH_ACTIVE),1)
release-patch release-minor release-major release-resume: export IC_METRICS_RELEASE_CACHE_PREPARE := 0
else
release-patch release-minor release-major release-resume: export IC_METRICS_RELEASE_CACHE_PREPARE := 1
endif

release-version:
	@bash scripts/release/metadata.sh version

release-preflight:
	+@RUST_TOOL_VERSIONS="$(RUST_TOOL_VERSIONS)" bash scripts/release/metadata.sh preflight

release-verify:
	+@bash scripts/release/metadata.sh verify

release-prepare-version:
	+@bash scripts/release/metadata.sh prepare
	+$(MAKE) --no-print-directory package-check OBSERVABILITY_RELEASE_VALIDATION_SCOPE=group

release-commit-check:
	+@bash scripts/release/metadata.sh commit-check

release-prepared-check release-committed-check release-tagged-check release-push-check:
	+@bash scripts/release/metadata.sh check

release-files:
	@bash scripts/release/metadata.sh files

.PHONY: help install-hooks hook-check check check-wasm clippy docs-check check-doc-links test msrv compiler-check compiler-policy-check toko-tooling-check check-pins release-tools-check ci
.PHONY: ci-evidence-check candid-boundary-check
.PHONY: production-dependencies-check cargo-boundaries-check
.PHONY: allocation-free-check
.PHONY: publication-source-check verify-publication publish-verified
.PHONY: ci-selection-check package-doc-links-check
.PHONY: metrics-profiles-check
.PHONY: install-release-editor release-editor-check
.PHONY: setup-smoke-check

setup-smoke-check:
	bash scripts/ci/check-setup-smoke.sh "$(MAKE_COMMAND)"


install-release-editor:
	+@bash scripts/dev/release-editor.sh install

release-editor-check:
	+@bash scripts/dev/release-editor.sh check

publication-source-check:
	@bash scripts/release/publication.sh admit

# Retain a separate upload receipt; a failed readback must never replay an upload.
publish-verified:
	+$(MAKE) --no-print-directory publish
	+$(MAKE) --no-print-directory verify-publication

verify-publication:
	@bash scripts/release/publication.sh verify

help:
	@echo "Local setup: install-tools; offline verification: tools-check"
	@echo "Reports: cloc (this workspace); CLOC_DEPTH=0 adds packages, CLOC_DEPTH=1 adds modules"
	@echo "Maintainer releases: release-patch, release-minor, release-major; release-resume VERSION=X.Y.Z"
	@echo "Normal releases start fresh from committed metadata; exact recovery requires VERSION and RELEASE_GROUP"
	@echo "Release/publication selection required: RELEASE_GROUP=metrics or logging (no default)"
	@echo "Registry: publish-check (dry run), publish (upload the selected group only)"
	@echo "Verified delivery: publish-verified (upload then readback); verify-publication (readback only)"
	@echo "Package overrides must belong to the selected group; release does not publish."
	@echo "Rust setup: install-rust-tools; offline verification: rust-tools-check"
	@echo "Release editor (also in install-tools/tools-check): install-release-editor, release-editor-check"
	@echo "Clone setup: install-hooks (requires prepared manifest formatter and rustfmt)"
	@echo "Workspace gates: check, check-wasm, clippy, docs-check, test (both packages; see docs/hosts.md for focused Cargo commands)"
	@echo "Formatting and admission: format-tools-check, fmt, fmt-check, check-doc-links, toko-tooling-check, check-pins"
	@echo "Dependency declarations and boundary fixtures: production-dependencies-check"
	@echo "Link fixed Metrics recording without an allocator: allocation-free-check"
	@echo "Early setup: setup-smoke-check"
	@echo "Dependency-free Metrics graphs: metrics-profiles-check; Logging graphs: logging-profiles-check"
	@echo "Release group-plan scope and recovery fixtures: release-validation-check"
	@echo "Renew matched full/selected mapping qualification: release-validation-qualify (on relevant changes)"
	@echo "Tooling fixtures: hook-check, release-tools-check (no release Git effects)"
	@echo "CI evidence fixture: ci-evidence-check (substitute action results and Make effects, no hosted run)"
	@echo "Owned Rust source encoding boundary: candid-boundary-check"
	@echo "Shared Cargo declaration boundaries: cargo-boundaries-check"
	@echo "Named tests: cargo test -p PACKAGE --locked <test-name> (ic-metrics or ic-logging)"
	@echo "Recording tests: cargo test -p $(PACKAGE) --features recording --locked <test-name>"
	@echo "Maintenance task definitions: tasks/README.md (adoption does not activate a schedule)"
	@echo "Workspace gates cover Metrics and Logging; compiler admission: msrv"
	@echo "Full workspace validation (explicit check request): ci; releases select a complete group plan"

.PHONY: package-check

# Verify both workspace archives offline. No registry upload or version mutation.
# Only the release adapter selects group scope. Ordinary commands and full CI
# retain workspace scope, even when RELEASE_GROUP is inherited.
override validation_cargo_selection = $(if $(filter group,$(OBSERVABILITY_RELEASE_VALIDATION_SCOPE)),-p ic-$(RELEASE_GROUP),--workspace)
override validation_candid_sources = $(if $(filter group,$(OBSERVABILITY_RELEASE_VALIDATION_SCOPE)),crates/ic-$(RELEASE_GROUP) scripts/release/fixtures/retained-consumer/tests/$(RELEASE_GROUP).rs,crates scripts/release/fixtures/retained-consumer/tests)
.PHONY: validation-scope-check release-validation-check release-validation-qualify logging-profiles-check
validation-scope-check:
	@case '$(OBSERVABILITY_RELEASE_VALIDATION_SCOPE)' in ''|workspace) ;; group) bash scripts/release/metadata.sh selection ;; *) exit 2 ;; esac
	@if test -n "$${OBSERVABILITY_RELEASE_VALIDATION_ATTEMPT:-}"; then perl scripts/release/validation.pl admit "$$OBSERVABILITY_RELEASE_VALIDATION_ATTEMPT" '$(OBSERVABILITY_RELEASE_VALIDATION_SCOPE)' '$(RELEASE_GROUP)'; fi

package-check:
	+cargo package $(validation_cargo_selection) --all-features --locked --offline --allow-dirty

hook-check:
	bash scripts/dev/test-format-hook.sh

ci-evidence-check:
	bash scripts/ci/test-native-source-files.sh
	bash scripts/ci/test-native-evidence.sh
	bash scripts/ci/test-native-recovery-evidence.sh

candid-boundary-check: | validation-scope-check
	perl scripts/ci/check-candid-boundary.pl --cbor "$(CURDIR)" ci/candid-boundary.json $(validation_candid_sources)

cargo-boundaries-check:
	bash scripts/ci/check-cargo-dependency-boundaries.sh --consumer "$(CURDIR)" --external-ic

check:
	+cargo check -p $(PACKAGE) --lib --no-default-features --locked
	+cargo check --workspace --all-targets --all-features --locked

check-wasm:
	+cargo check -p $(PACKAGE) --lib --no-default-features --locked --target wasm32-unknown-unknown
	+cargo check --workspace --all-features --locked --target wasm32-unknown-unknown

clippy:
	+cargo clippy $(validation_cargo_selection) --all-targets --all-features --locked -- -D warnings
	+cargo clippy $(validation_cargo_selection) --lib --all-features --locked --target wasm32-unknown-unknown -- -D warnings

docs-check:
	+RUSTDOCFLAGS="-D warnings" cargo doc $(validation_cargo_selection) --all-features --locked --no-deps
	+RUSTDOCFLAGS="-D warnings" cargo doc $(validation_cargo_selection) --all-features --locked --no-deps --target wasm32-unknown-unknown

check-doc-links:
	perl scripts/ci/check-documentation-links.pl --root "$(CURDIR)" \
		README.md AGENTS.md TOKO-TOOLING.md CHANGELOG.md releases/*/*.md releases/history.md docs/*.md \
		docs/principles/*.md docs/evidence/*.md docs/evidence/releases/*.md docs/status/*.md rules/*.md audits/*.md tasks/*.md \
		qualification/*/README.md
	perl scripts/ci/check-documentation-links.pl --root "$(CURDIR)" \
		crates/ic-metrics/src/*.md crates/ic-metrics/README.md crates/ic-metrics/CHANGELOG.md \
		crates/ic-logging/README.md crates/ic-logging/CHANGELOG.md

test:
	+cargo test $(validation_cargo_selection) --all-features --locked


ci-selection-check:
	bash scripts/ci/test-ci-selection.sh

package-doc-links-check:
	perl scripts/ci/tests/package-doc-links.t
	perl scripts/ci/check-package-doc-links.pl

metrics-profiles-check:
	perl scripts/ci/check-metrics-profiles.pl metrics

logging-profiles-check:
	perl scripts/ci/check-metrics-profiles.pl logging

release-validation-check:
	bash scripts/release/test-validation-plan.sh

# Renew matched full/selected mapping evidence after changes to mapping/runner/
# configuration/contracts, or by explicit request; ordinary CI keeps wiring tests.
release-validation-qualify:
	bash scripts/release/test-validation-plan.sh --qualify

compiler-check:
	+bash scripts/ci/check-rust-compiler.sh

# Compatibility entry point: compilation is covered once by ci.
msrv: compiler-check

compiler-policy-check:
	bash scripts/ci/test-rust-compiler.sh

check-pins:
	bash scripts/ci/check-dependency-pins.sh --cargo-inheritance

production-dependencies-check: candid-boundary-check cargo-boundaries-check
	perl scripts/ci/tests/check-process.t
	perl scripts/ci/check-production-dependencies.pl
	bash scripts/ci/test-production-dependencies.sh

allocation-free-check:
	+bash scripts/ci/check-allocation-free.sh

# Retention owns the separate release/publication/hook bodies and custody cases.
release-tools-check:
	bash scripts/release/test-tooling-admission.sh
	bash scripts/release/test-retained-consumer.sh
	bash scripts/release/test-fixture-retention.sh
	bash scripts/release/test-publication-policy.sh
	bash scripts/release/test-release-batch.sh

# One full stage roster drives CI and release selection.
include make/validation.mk

# Make admits Cargo recipes; script entrypoints own their compiler admission.
clippy docs-check test package-check: | validation-scope-check
check check-wasm clippy docs-check test package-check metrics-profiles-check logging-profiles-check production-dependencies-check publication-source-check: | compiler-check
