#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/mattkelly-deploy-simulation.XXXXXX")
pid=
cleanup() {
  [ -z "$pid" ] || kill "$pid" >/dev/null 2>&1 || true
  chmod -R u+w "$tmp_dir" 2>/dev/null || true
  rm -rf "$tmp_dir"
}
trap cleanup EXIT HUP INT TERM

make_release() {
  id=$1
  release="$tmp_dir/source/$id"
  mkdir -p "$release/public/assets/css"
  for path in index.html projects/index.html cv/index.html blog/index.html references/index.html dragonruby/index.html 404.html; do
    mkdir -p "$release/public/$(dirname "$path")"
    printf '<!doctype html><title>%s</title><h1>%s</h1>\n' "$id" "$id" > "$release/public/$path"
  done
  printf '%s\n' 'fixture' > "$release/public/assets/css/site.css"
  printf '%s\n' 'User-agent: *' > "$release/public/robots.txt"
  printf '%s\n' '<urlset></urlset>' > "$release/public/sitemap.xml"
  (
    cd "$release"
    find public -type f -print | LC_ALL=C sort | while IFS= read -r path; do shasum -a 256 "$path"; done > release-files.sha256
  )
  inventory_hash=$(shasum -a 256 "$release/release-files.sha256" | cut -d' ' -f1)
  cat > "$release/release-manifest.env" <<EOF
MANIFEST_VERSION=1
RELEASE_ID=$id
RELEASE_PROFILE=core-only-preview
REPOSITORY_SHA=0000000000000000000000000000000000000000
REPOSITORY_STATE=clean
CORE_VALIDATION=passed
QUARTZ_VALIDATION=not-included
VALIDATION_SUMMARY=core:passed,quartz:not-included
QUARTZ_ARTIFACT_SOURCE_REVISION=none
QUARTZ_TOOLCHAIN_VERSION=fixture
QUARTZ_TOOLCHAIN_REVISION=0000000000000000000000000000000000000000
QUARTZ_TOOLCHAIN_TREE=0000000000000000000000000000000000000000
QUARTZ_COMPILER_SHA256=0000000000000000000000000000000000000000000000000000000000000000
LLVM_VERSION=fixture
TOOLCHAIN_OS=fixture
TOOLCHAIN_ARCH=fixture
FILE_MANIFEST_SHA256=$inventory_hash
EOF
}

mkdir -p "$tmp_dir/source" "$tmp_dir/deploy"
make_release 20260716T000000Z-known-good
make_release 20260716T000100Z-candidate
make_release 20260715T235900Z-stale
DEPLOY_HOST=preview.invalid DEPLOY_INCOMING_ROOT=/srv/incoming \
  "$ROOT/bin/release-transfer" --dry-run "$tmp_dir/source/20260716T000100Z-candidate" > "$tmp_dir/transfer-dry-run"
grep -F 'Would transfer' "$tmp_dir/transfer-dry-run" >/dev/null

smoke_env=
if command -v caddy >/dev/null 2>&1; then
  PORTFOLIO_ADDRESS=http://127.0.0.1:18080 \
  PORTFOLIO_ROOT="$tmp_dir/deploy/current/public" \
  SOUL_ADDRESS=http://127.0.0.1:18081 \
  SOUL_UPSTREAM=http://127.0.0.1:19090 \
  caddy run --config "$ROOT/ops/caddy/Caddyfile" --adapter caddyfile > "$tmp_dir/caddy.log" 2>&1 &
  pid=$!
  attempt=0
  while [ "$attempt" -lt 50 ]; do
    if curl -sS -o /dev/null http://127.0.0.1:18080/ 2>/dev/null; then break; fi
    attempt=$((attempt + 1))
    sleep 0.1
  done
  [ "$attempt" -lt 50 ] || { printf '%s\n' 'simulate-local: Caddy did not start' >&2; exit 1; }
  smoke_env=http://127.0.0.1:18080
fi

DEPLOY_ROOT="$tmp_dir/deploy" SMOKE_BASE_URL="$smoke_env" \
  "$ROOT/bin/release-rehearse-rollback" \
  "$tmp_dir/source/20260716T000000Z-known-good" \
  "$tmp_dir/source/20260716T000100Z-candidate"

if [ -n "$smoke_env" ]; then
  [ "$(curl -sS -X POST -o /dev/null -w '%{http_code}' http://127.0.0.1:18080/)" = "405" ]
  [ "$(curl -sS -o /dev/null -w '%{http_code}' http://127.0.0.1:18081/api/soul/spawn)" = "404" ]
  [ "$(curl -sS -X POST -o /dev/null -w '%{http_code}' http://127.0.0.1:18081/health)" = "405" ]
fi

stale_incoming="$tmp_dir/deploy/incoming/20260715T235900Z-stale"
mkdir "$stale_incoming"
cp -R "$tmp_dir/source/20260715T235900Z-stale/." "$stale_incoming/"
touch "$stale_incoming/.transfer-complete"
DEPLOY_ROOT="$tmp_dir/deploy" "$ROOT/bin/release-stage" "$stale_incoming"
if DEPLOY_ROOT="$tmp_dir/deploy" "$ROOT/bin/release-activate" 20260715T235900Z-stale > "$tmp_dir/preview-rejection" 2>&1; then
  printf '%s\n' 'simulate-local: production activation accepted a preview release' >&2
  exit 1
fi
[ "$(readlink "$tmp_dir/deploy/current")" = "releases/20260716T000000Z-known-good" ]
DEPLOY_ROOT="$tmp_dir/deploy" RELEASE_KEEP=0 "$ROOT/bin/release-prune" > "$tmp_dir/prune-dry-run"
grep -F 'Dry run only' "$tmp_dir/prune-dry-run" >/dev/null
grep -F '20260715T235900Z-stale' "$tmp_dir/prune-dry-run" >/dev/null
DEPLOY_ROOT="$tmp_dir/deploy" RELEASE_KEEP=0 "$ROOT/bin/release-prune" --execute
[ -d "$tmp_dir/deploy/releases/20260716T000000Z-known-good" ]
[ -d "$tmp_dir/deploy/releases/20260716T000100Z-candidate" ]
[ ! -e "$tmp_dir/deploy/releases/20260715T235900Z-stale" ]
printf '%s\n' 'Local stage, activation, smoke (when Caddy is available), rollback, and prune simulation passed.'
