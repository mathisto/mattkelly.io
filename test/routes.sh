#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
PORT=${PORTFOLIO_TEST_PORT:-$((20000 + ($$ % 10000)))}
SOUL_PORT=$((PORT + 1))
WWW_PORT=$((PORT + 2))
QUARTZ_ALIAS_PORT=$((PORT + 3))
CHIP8_PORT=$((PORT + 4))
SOUL_ALIAS_PORT=$((PORT + 5))
BASE="http://127.0.0.1:$PORT"
tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/mattkelly-routes.XXXXXX")
pid=
cleanup() {
  [ -z "$pid" ] || kill "$pid" >/dev/null 2>&1 || true
  rm -rf "$tmp_dir"
}
trap cleanup EXIT HUP INT TERM

fail() { printf 'routes: %s\n' "$1" >&2; exit 1; }
code() { curl -sS -o /dev/null -w '%{http_code}' "$BASE$1"; }
location() { curl -sS -o /dev/null -w '%{redirect_url}' "$BASE$1"; }
expect_code() { [ "$(code "$1")" = "$2" ] || fail "$1 did not return $2"; }
expect_redirect() {
  [ "$(code "$1")" = "308" ] || fail "$1 did not return 308"
  case "$(location "$1")" in *"$2") ;; *) fail "$1 did not redirect to $2" ;; esac
}
expect_security_headers() {
  path=$1
  headers="$tmp_dir/headers$(printf '%s' "$path" | tr '/' '_')"
  curl -sS -D "$headers" -o /dev/null "$BASE$path"
  grep -i "^Content-Security-Policy:.*default-src 'none'.*frame-ancestors 'none'" "$headers" >/dev/null || fail "$path CSP is missing or incomplete"
  grep -i '^Strict-Transport-Security: max-age=31536000; includeSubDomains' "$headers" >/dev/null || fail "$path HSTS is missing"
  grep -i '^X-Content-Type-Options: nosniff' "$headers" >/dev/null || fail "$path nosniff is missing"
  grep -i '^X-Frame-Options: DENY' "$headers" >/dev/null || fail "$path frame denial is missing"
  grep -i '^Referrer-Policy: strict-origin-when-cross-origin' "$headers" >/dev/null || fail "$path referrer policy is missing"
  grep -i '^Permissions-Policy: camera=(), geolocation=(), microphone=()' "$headers" >/dev/null || fail "$path permissions policy is missing"
  grep -i '^Cache-Control: no-cache' "$headers" >/dev/null || fail "$path error-safe cache policy is missing"
  if grep -i '^Server:' "$headers" >/dev/null; then fail "$path exposed the server header"; fi
}

command -v caddy >/dev/null 2>&1 || fail "caddy is required for route contract tests"
PORTFOLIO_ADDRESS="http://127.0.0.1:$PORT" PORTFOLIO_ROOT="$ROOT/dist" SOUL_ADDRESS="http://127.0.0.1:$SOUL_PORT" WWW_ADDRESS="http://127.0.0.1:$WWW_PORT" QUARTZ_ALIAS_ADDRESS="http://127.0.0.1:$QUARTZ_ALIAS_PORT" CHIP8_ADDRESS="http://127.0.0.1:$CHIP8_PORT" SOUL_ALIAS_ADDRESS="http://127.0.0.1:$SOUL_ALIAS_PORT" SOUL_UPSTREAM="http://127.0.0.1:19090" caddy validate --config "$ROOT/ops/caddy/Caddyfile" --adapter caddyfile >/dev/null
PORTFOLIO_ADDRESS="http://127.0.0.1:$PORT" PORTFOLIO_ROOT="$ROOT/dist" SOUL_ADDRESS="http://127.0.0.1:$SOUL_PORT" WWW_ADDRESS="http://127.0.0.1:$WWW_PORT" QUARTZ_ALIAS_ADDRESS="http://127.0.0.1:$QUARTZ_ALIAS_PORT" CHIP8_ADDRESS="http://127.0.0.1:$CHIP8_PORT" SOUL_ALIAS_ADDRESS="http://127.0.0.1:$SOUL_ALIAS_PORT" SOUL_UPSTREAM="http://127.0.0.1:19090" caddy run --config "$ROOT/ops/caddy/Caddyfile" --adapter caddyfile >"$tmp_dir/caddy.log" 2>&1 &
pid=$!

attempt=0
while [ "$attempt" -lt 50 ]; do
  if curl -sS -o /dev/null "$BASE/" 2>/dev/null; then break; fi
  attempt=$((attempt + 1))
  sleep 0.1
done
[ "$attempt" -lt 50 ] || fail "Caddy did not start"

for path in / /work/ /work/va-public-apis/ /work/legacy-recovery/ /work/data-advertising-systems/ /work/nuclear-to-software/ /lab/ /lab/quartz/ /lab/soul-of-quartz/ /lab/chip-8/ /lab/home-lab/ /lab/dragonruby/ /lab/scribe/ /lab/site-evolution/ /writing/ /about/ /resume/ /references/ /now/ /provenance/ /site-history/ /blog/building-mattkelly-io/ /assets/css/site.css /sitemap.xml /robots.txt /favicon.ico /icon.png; do
  expect_code "$path" 200
done
expect_code /missing-route 404
expect_code /quartz/missing 404
expect_code /CV.pdf 410
expect_code /CV.docx 410

expect_redirect /projects /work/
expect_redirect /projects/ /work/
expect_redirect /cv /resume/
expect_redirect /cv/ /resume/
expect_redirect /work /work/
expect_redirect /lab /lab/
expect_redirect /writing /writing/
expect_redirect /about /about/
expect_redirect /resume /resume/
expect_redirect /blog /writing/
expect_redirect /blog/ /writing/
expect_redirect /references /references/
expect_redirect /now /now/
expect_redirect /provenance /provenance/
expect_redirect /site-history /site-history/
expect_redirect /dragonruby /lab/dragonruby/
expect_redirect /dragonruby/ /lab/dragonruby/
for tutorial in "$ROOT"/dragonruby/[0-9][0-9][0-9]-*.md; do
  slug=$(basename "$tutorial" .md)
  expect_redirect "/dragonruby/$slug" /lab/dragonruby/
done
expect_redirect /blog/building-mattkelly-io /blog/building-mattkelly-io/
expect_redirect /blog/hello-world /blog/building-mattkelly-io/
expect_redirect /blog/hello-world/ /blog/building-mattkelly-io/
expect_redirect /quartz/ /quartz

if [ -f "$ROOT/dist/quartz/index.html" ]; then
  expect_code /quartz 200
else
  expect_code /quartz 404
fi

for soul_port in "$SOUL_PORT" "$SOUL_ALIAS_PORT"; do
  [ "$(curl -sS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$soul_port/health")" = "502" ] || fail "Soul $soul_port /health was not proxied"
  [ "$(curl -sS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$soul_port/api/soul/stats.json")" = "502" ] || fail "Soul $soul_port stats were not proxied"
  for path in / /anything /api/soul/tasks.json /api/soul/stats.json/extra /health/; do
    [ "$(curl -sS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$soul_port$path")" = "404" ] || fail "Soul $soul_port $path escaped default deny"
  done
  for path in //health ///health /./health /x/../health /%68ealth /api/soul%2fstats.json //api/soul/stats.json /api//soul/stats.json /api/soul/../soul/stats.json; do
    [ "$(curl --path-as-is -sS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$soul_port$path")" = "404" ] || fail "Soul $soul_port raw URI $path escaped default deny"
  done
  for method in POST PUT PATCH DELETE OPTIONS; do
    [ "$(curl -X "$method" -sS -o /dev/null -w '%{http_code}' "http://127.0.0.1:$soul_port/health")" = "405" ] || fail "Soul $soul_port $method escaped method deny"
  done
done
for redirect in "$WWW_PORT|https://mattkelly.io/example" "$QUARTZ_ALIAS_PORT|https://mattkelly.io/quartz/example" "$CHIP8_PORT|https://mattkelly.io/quartz/chip8/"; do
  redirect_port=${redirect%%|*}
  redirect_target=${redirect#*|}
  actual=$(curl -sS -o /dev/null -w '%{http_code}|%{redirect_url}' "http://127.0.0.1:$redirect_port/example")
  [ "$actual" = "308|$redirect_target" ] || fail "legacy host redirect contract failed: $actual"
done
expect_security_headers /
expect_security_headers /quartz/missing

printf '%s\n' 'Caddy route contract tests passed.'
