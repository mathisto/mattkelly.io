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

if command -v sha256sum >/dev/null 2>&1; then
  RELEASE_SHA256_TOOL=sha256sum
  export RELEASE_SHA256_TOOL
fi
RELEASE_COMMAND=simulate-local
. "$ROOT/bin/release-lib"

make_release() {
  id=$1
  release="$tmp_dir/source/$id"
  mkdir -p "$release/public/assets/css"
  for path in index.html work/index.html lab/index.html writing/index.html about/index.html resume/index.html references/index.html now/index.html provenance/index.html site-history/index.html blog/building-mattkelly-io/index.html 404.html; do
    mkdir -p "$release/public/$(dirname "$path")"
    printf '<!doctype html><title>%s</title><h1>%s</h1>\n' "$id" "$id" > "$release/public/$path"
  done
  printf '%s\n' 'fixture' > "$release/public/assets/css/site.css"
  printf '%s\n' 'User-agent: *' > "$release/public/robots.txt"
  printf '%s\n' '<urlset></urlset>' > "$release/public/sitemap.xml"
  (
    cd "$release"
    find public -type f -print | LC_ALL=C sort | while IFS= read -r path; do
      printf '%s  %s\n' "$(release_sha256_digest "$path")" "$path"
    done > release-files.sha256
  )
  inventory_hash=$(release_sha256_digest "$release/release-files.sha256")
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
  portfolio_port=$((30000 + ($$ % 10000)))
  soul_port=$((portfolio_port + 1))
  www_port=$((portfolio_port + 2))
  quartz_alias_port=$((portfolio_port + 3))
  chip8_port=$((portfolio_port + 4))
  soul_alias_port=$((portfolio_port + 5))
  placeholder_port=$((portfolio_port + 6))
  DEV_ADDRESS="http://127.0.0.1:$portfolio_port" \
  PORTFOLIO_ADDRESS="http://127.0.0.1:$placeholder_port" \
  PORTFOLIO_ROOT="$tmp_dir/deploy/current/public" \
  SOUL_ADDRESS="http://127.0.0.1:$soul_port" \
  WWW_ADDRESS="http://127.0.0.1:$www_port" \
  QUARTZ_ALIAS_ADDRESS="http://127.0.0.1:$quartz_alias_port" \
  CHIP8_ADDRESS="http://127.0.0.1:$chip8_port" \
  SOUL_ALIAS_ADDRESS="http://127.0.0.1:$soul_alias_port" \
  SOUL_UPSTREAM=http://127.0.0.1:19090 \
  caddy run --config "$ROOT/ops/caddy/Caddyfile" --adapter caddyfile > "$tmp_dir/caddy.log" 2>&1 &
  pid=$!
  attempt=0
  while [ "$attempt" -lt 50 ]; do
    if curl -sS -o /dev/null "http://127.0.0.1:$portfolio_port/" 2>/dev/null; then break; fi
    attempt=$((attempt + 1))
    sleep 0.1
  done
  [ "$attempt" -lt 50 ] || { printf '%s\n' 'simulate-local: Caddy did not start' >&2; exit 1; }
  smoke_env="http://127.0.0.1:$portfolio_port"
fi

DEPLOY_ROOT="$tmp_dir/deploy" SMOKE_BASE_URL="$smoke_env" \
  "$ROOT/bin/release-rehearse-rollback" \
  "$tmp_dir/source/20260716T000000Z-known-good" \
  "$tmp_dir/source/20260716T000100Z-candidate"

test_activation_interruption() {
  point=$1
  if DEPLOY_ROOT="$tmp_dir/deploy" RELEASE_TEST_INTERRUPT="$point" "$ROOT/bin/release-activate" --allow-core-preview 20260716T000100Z-candidate >/dev/null 2>&1; then
    printf 'simulate-local: activation interruption %s unexpectedly succeeded\n' "$point" >&2
    exit 1
  fi
  [ -f "$tmp_dir/deploy/.activation-intent" ]
  DEPLOY_ROOT="$tmp_dir/deploy" "$ROOT/bin/release-activate" --allow-core-preview 20260716T000100Z-candidate
  [ "$(readlink "$tmp_dir/deploy/current")" = "releases/20260716T000100Z-candidate" ]
  [ "$(readlink "$tmp_dir/deploy/previous")" = "releases/20260716T000000Z-known-good" ]
  DEPLOY_ROOT="$tmp_dir/deploy" "$ROOT/bin/release-rollback" --allow-core-preview
  [ "$(readlink "$tmp_dir/deploy/current")" = "releases/20260716T000000Z-known-good" ]
}

test_activation_interruption before-previous
test_activation_interruption after-previous
test_activation_interruption before-current
test_activation_interruption kill-after-current

DEPLOY_ROOT="$tmp_dir/deploy" "$ROOT/bin/release-activate" --allow-core-preview 20260716T000100Z-candidate
if DEPLOY_ROOT="$tmp_dir/deploy" RELEASE_TEST_INTERRUPT=kill-after-intent "$ROOT/bin/release-rollback" --allow-core-preview >/dev/null 2>&1; then
  printf '%s\n' 'simulate-local: rollback interruption injection unexpectedly succeeded' >&2
  exit 1
fi
[ -f "$tmp_dir/deploy/.rollback-intent" ]
[ -d "$tmp_dir/deploy/.deploy.lock" ]
DEPLOY_ROOT="$tmp_dir/deploy" "$ROOT/bin/release-rollback" --allow-core-preview
[ "$(readlink "$tmp_dir/deploy/current")" = "releases/20260716T000000Z-known-good" ]

DEPLOY_ROOT="$tmp_dir/deploy" "$ROOT/bin/release-activate" --allow-core-preview 20260716T000100Z-candidate
if DEPLOY_ROOT="$tmp_dir/deploy" RELEASE_TEST_INTERRUPT=after-current "$ROOT/bin/release-rollback" --allow-core-preview >/dev/null 2>&1; then
  printf '%s\n' 'simulate-local: post-switch interruption injection unexpectedly succeeded' >&2
  exit 1
fi
[ "$(readlink "$tmp_dir/deploy/current")" = "releases/20260716T000000Z-known-good" ]
[ -f "$tmp_dir/deploy/.rollback-intent" ]
DEPLOY_ROOT="$tmp_dir/deploy" "$ROOT/bin/release-rollback" --allow-core-preview
[ "$(readlink "$tmp_dir/deploy/previous")" = "releases/20260716T000100Z-candidate" ]

containment_root="$tmp_dir/containment"
mkdir "$containment_root"
ln -s "$tmp_dir/deploy/releases" "$containment_root/releases"
if DEPLOY_ROOT="$containment_root" "$ROOT/bin/release-activate" --allow-core-preview 20260716T000100Z-candidate >/dev/null 2>&1; then
  printf '%s\n' 'simulate-local: activation accepted a symlinked releases directory' >&2
  exit 1
fi
saved_current=$(readlink "$tmp_dir/deploy/current")
rm "$tmp_dir/deploy/current"
ln -s 'releases/../outside' "$tmp_dir/deploy/current"
if DEPLOY_ROOT="$tmp_dir/deploy" "$ROOT/bin/release-activate" --allow-core-preview 20260716T000100Z-candidate >/dev/null 2>&1; then
  printf '%s\n' 'simulate-local: activation accepted a traversal link target' >&2
  exit 1
fi
rm "$tmp_dir/deploy/current"
ln -s "$saved_current" "$tmp_dir/deploy/current"

production_root="$tmp_dir/production"
mkdir "$production_root" "$production_root/releases"
cp -R "$tmp_dir/source/20260716T000100Z-candidate" "$production_root/releases/"
if PRODUCTION_DEPLOY_ROOT="$production_root" DEPLOY_ROOT="$production_root/." "$ROOT/bin/release-activate" --allow-core-preview 20260716T000100Z-candidate >/dev/null 2>&1; then
  printf '%s\n' 'simulate-local: canonical production-root alias bypassed preview protection' >&2
  exit 1
fi
ln -s "$production_root" "$tmp_dir/production-link"
if PRODUCTION_DEPLOY_ROOT="$production_root" DEPLOY_ROOT="$tmp_dir/production-link" "$ROOT/bin/release-activate" --allow-core-preview 20260716T000100Z-candidate >/dev/null 2>&1; then
  printf '%s\n' 'simulate-local: symlinked requested production root bypassed preview protection' >&2
  exit 1
fi

if [ -n "$smoke_env" ]; then
  [ "$(curl -sS -X POST -o /dev/null -w '%{http_code}' "http://127.0.0.1:$portfolio_port/")" = "405" ]
  [ "$(curl -sS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$soul_port/api/soul/spawn")" = "404" ]
  [ "$(curl -sS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$soul_port/anything-else")" = "404" ]
  [ "$(curl -sS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$soul_port/health")" = "502" ]
  [ "$(curl -sS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$soul_port/api/soul/stats.json")" = "502" ]
  [ "$(curl -sS -X POST -o /dev/null -w '%{http_code}' "http://127.0.0.1:$soul_port/health")" = "405" ]
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
printf '%s\n' 'Local transfer dry-run, stage, activation and rollback interruption recovery, production-root containment, canonical-route smoke, Soul default-deny, and prune simulation passed.'
