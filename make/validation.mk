# Consumer-owned full-CI entry; one declared roster also drives release plans.
# Shared companions: scripts/ci/observability-ci.sh
.PHONY: ci workspace-ci
ci:
	+$(MAKE) --no-print-directory workspace-ci OBSERVABILITY_RELEASE_VALIDATION_SCOPE=workspace

workspace-ci:
	+@bash scripts/ci/observability-ci.sh
