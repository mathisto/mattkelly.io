#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
PORT=${PORTFOLIO_TEST_PORT:-18080}
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

command -v caddy >/dev/null 2>&1 || fail "caddy is required for route contract tests"
PORTFOLIO_ADDRESS="http://127.0.0.1:$PORT" PORTFOLIO_ROOT="$ROOT/dist" caddy validate --config "$ROOT/ops/caddy/Caddyfile" --adapter caddyfile >/dev/null
PORTFOLIO_ADDRESS="http://127.0.0.1:$PORT" PORTFOLIO_ROOT="$ROOT/dist" caddy run --config "$ROOT/ops/caddy/Caddyfile" --adapter caddyfile >"$tmp_dir/caddy.log" 2>&1 &
pid=$!

attempt=0
while [ "$attempt" -lt 50 ]; do
  if curl -sS -o /dev/null "$BASE/" 2>/dev/null; then break; fi
  attempt=$((attempt + 1))
  sleep 0.1
done
[ "$attempt" -lt 50 ] || fail "Caddy did not start"

for path in / /projects/ /cv/ /blog/ /blog/building-mattkelly-io/ /references/ /dragonruby/ /assets/css/site.css /sitemap.xml /robots.txt /favicon.ico /icon.png; do
  expect_code "$path" 200
done
expect_code /missing-route 404
expect_code /CV.pdf 410
expect_code /CV.docx 410

expect_redirect /projects /projects/
expect_redirect /cv /cv/
expect_redirect /blog /blog/
expect_redirect /references /references/
expect_redirect /dragonruby /dragonruby/
expect_redirect /blog/building-mattkelly-io /blog/building-mattkelly-io/
expect_redirect /blog/hello-world /blog/building-mattkelly-io/
expect_redirect /blog/hello-world/ /blog/building-mattkelly-io/
expect_redirect /quartz/ /quartz

if [ -f "$ROOT/dist/quartz/index.html" ]; then
  expect_code /quartz 200
else
  expect_code /quartz 404
fi

printf '%s\n' 'Caddy route contract tests passed.'
