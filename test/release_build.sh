#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
snapshot_skip_message='Release-build regression skipped in validated Git-less snapshot.'
if [ ! -e "$ROOT/.git" ]; then
  printf '%s\n' "$snapshot_skip_message"
  exit 0
fi
unset GIT_DIR GIT_WORK_TREE
[ "$(git -C "$ROOT" rev-parse --is-inside-work-tree)" = "true" ] || {
  printf '%s\n' 'release-build test: repository metadata does not identify a Git worktree' >&2
  exit 1
}

QUARTZ_CHECKOUT=${QUARTZ_CHECKOUT:-"$ROOT/../quartz"}
export QUARTZ_CHECKOUT
tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/mattkelly-release-build.XXXXXX")
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM
fixture_root="$tmp_dir/repository"
snapshot_root="$tmp_dir/gitless-snapshot"
artifact="$tmp_dir/artifact"
output="$tmp_dir/releases/complete-fixture"

mkdir -p "$snapshot_root/test"
cp "$ROOT/test/release_build.sh" "$snapshot_root/test/release_build.sh"
snapshot_result=$(PORTFOLIO_RELEASE_BUILD_TEST_ACTIVE=1 GIT_DIR="$ROOT/.git" GIT_WORK_TREE="$ROOT" "$snapshot_root/test/release_build.sh")
[ "$snapshot_result" = "$snapshot_skip_message" ] || {
  printf '%s\n' 'release-build test: Git-less snapshot did not report the expected recursive-test skip' >&2
  exit 1
}

git clone --quiet "$ROOT" "$fixture_root"
mkdir -p "$fixture_root/test" "$artifact" "$(dirname "$output")"
cp "$ROOT/bin/release-build" "$fixture_root/bin/release-build"
cp "$ROOT/bin/verify" "$fixture_root/bin/verify"
cp "$ROOT/test/release_build.sh" "$fixture_root/test/release_build.sh"
git -C "$fixture_root" add bin/release-build bin/verify test/release_build.sh
if ! git -C "$fixture_root" diff --cached --quiet; then
  git -C "$fixture_root" -c user.name=release-test -c user.email=release-test.invalid commit --quiet -m 'Apply release-build regression fixture'
fi

printf '%s\n' '<!doctype html><html lang="en"><head><title>Quartz</title><meta name="description" content="Fixture"><link rel="canonical" href="/quartz"><meta property="og:title" content="Quartz"><meta property="og:description" content="Fixture"><meta property="og:type" content="website"><meta property="og:url" content="/quartz"><meta name="twitter:card" content="summary"></head><body><h1>Quartz artifact fixture</h1></body></html>' > "$artifact/index.html"
printf '%s\n' 'ARTIFACT_KIND=quartz-site' 'PUBLIC_BASE=/quartz' 'SOURCE_REVISION=0000000000000000000000000000000000000000' 'VALIDATION_SCOPE=integrity-and-route-contract' 'NETWORK_PROFILE=static-no-external-requests-v1' > "$artifact/artifact-contract.env"
(
  cd "$artifact"
  shasum -a 256 artifact-contract.env index.html > artifact-manifest.sha256
)

QUARTZ_ARTIFACT="$artifact" "$fixture_root/bin/release-build" "$output" >/dev/null
[ -s "$output/public/quartz/index.html" ]
grep -Fx 'RELEASE_PROFILE=complete' "$output/release-manifest.env" >/dev/null
grep -Fx 'QUARTZ_VALIDATION=passed' "$output/release-manifest.env" >/dev/null

if QUARTZ_ARTIFACT="$artifact" "$fixture_root/bin/verify" >/dev/null 2>&1; then
  printf '%s\n' 'release-build test: core verification accepted QUARTZ_ARTIFACT leakage' >&2
  exit 1
fi

printf '%s\n' 'Complete fixture release reached assembly without leaking QUARTZ_ARTIFACT into core verification.'
