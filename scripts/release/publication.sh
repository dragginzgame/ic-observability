#!/usr/bin/env bash
set -euo pipefail
# Observability owns the tag/package policy; Shared owns observation/provenance.
[[ $# == 1 && ( "$1" == admit || "$1" == verify ) ]] || exit 2
operation="$1"
root="$(git rev-parse --show-toplevel)"
cd "$root"
plan="$(bash scripts/release/metadata.sh plan)"
package="$(jq -er .primary <<< "$plan")"
version="$(jq -er .previous <<< "$plan")"
path="$(jq -er --arg package "$package" '.dependencies[] | select(.package == $package) | .path' <<< "$plan")"
repository="$(yq -p toml -o json -r '.workspace.package.repository' Cargo.toml)"
if [[ "$operation" == admit ]]; then
    case "${OBSERVABILITY_PUBLICATION_MODE:?select publication mode}" in
        check) exit ;;
        publish) ;;
        *) exit 2 ;;
    esac
fi
tag="${RELEASE_GROUP:?}-v$version"
[[ "$(git cat-file -t "refs/tags/$tag")" == tag ]] || { echo 'Publication requires an annotated group release tag' >&2; exit 1; }
source="$(git rev-parse --verify "refs/tags/$tag^{commit}")"
if [[ "$operation" == admit ]]; then
    [[ -z "$(git status --porcelain --untracked-files=all)" && "$(git rev-parse HEAD)" == "$source" ]] || {
        echo 'Upload from the clean checkout of the selected group release tag' >&2; exit 1;
    }
    mkdir -p target/publication
    admission="$(mktemp -d target/publication/admission.XXXXXX)"
    git ls-remote --exit-code --tags -- "$repository" "refs/tags/$tag" "refs/tags/$tag^{}" > "$admission/remote-tags"
    [[ "$(awk -v ref="refs/tags/$tag" '$2 == ref { print $1 }' "$admission/remote-tags")" == "$(git rev-parse "refs/tags/$tag")" ]]
    [[ "$(awk -v ref="refs/tags/$tag^{}" '$2 == ref { print $1 }' "$admission/remote-tags")" == "$source" ]]
    exit
fi
mkdir -p target/publication
attempt="$(mktemp -d target/publication/verification.XXXXXX)"
printf 'Registry verification evidence: %s\n' "$root/$attempt"
printf '%s\n' "$RELEASE_GROUP" "$package@$version" "$source" > "$attempt/selection"
status=0
bash scripts/ci/check-crates-io-version.sh --metadata "$attempt/registry" "$package" "$version" > "$attempt/observation.json" || status=$?
case "$status" in
    0) ;;
    1) echo 'Version is absent; no upload is attempted by verification' >&2; exit 1 ;;
    *) echo 'Registry state is unknown; retain evidence and reconcile before another upload' >&2; exit 2 ;;
esac
jq -e '.yanked == false' "$attempt/observation.json" > /dev/null
mkdir "$attempt/archives"
archive="$attempt/archives/$package-$version.crate"
curl --disable --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
    --connect-timeout 10 --max-time 60 --max-filesize 16777216 \
    "https://static.crates.io/crates/$package/$package-$version.crate" -o "$archive"
checksum="$(bash scripts/ci/verify-file-checksum.sh --print sha256 "$archive")"
[[ "$checksum" == "$(jq -er .checksum "$attempt/observation.json")" ]]
bash scripts/ci/check-cargo-package-provenance.sh "$attempt/provenance" "$attempt/archives" \
    "$repository" "$source" --package "$package@$version" "$path"
perl scripts/release/check-package-content.pl "$archive" "$attempt/provenance/source.git" \
    "$source" "$package@$version" "$path" > "$attempt/content-verified"
cat "$attempt/content-verified"
printf '%s\n' "$package@$version $source $checksum" > "$attempt/verified"
cat "$attempt/verified"
