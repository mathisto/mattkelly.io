#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/mattkelly-artifact.XXXXXX")
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM
artifact="$tmp_dir/artifact"
mkdir "$artifact"

expect_network_reject() {
  name=$1
  extension=$2
  content=$3
  fixture="$tmp_dir/$name"
  mkdir "$fixture"
  printf '%s\n' "$content" > "$fixture/case.$extension"
  if "$ROOT/bin/check-artifact-network" "$fixture" >/dev/null 2>&1; then
    printf 'artifact test: network fixture was accepted: %s\n' "$name" >&2
    exit 1
  fi
}

expect_assembly_reject() {
  name=$1
  filename=$2
  content=$3
  fixture="$tmp_dir/assembly-$name"
  mkdir "$fixture"
  printf '%s\n' '<!doctype html><html><head><title>Fixture</title><link rel="canonical" href="/quartz"></head><body><h1>Fixture</h1></body></html>' > "$fixture/index.html"
  printf '%s\n' 'ARTIFACT_KIND=quartz-site' 'PUBLIC_BASE=/quartz' 'SOURCE_REVISION=0000000000000000000000000000000000000000' 'VALIDATION_SCOPE=integrity-and-route-contract' 'NETWORK_PROFILE=static-no-external-requests-v1' > "$fixture/artifact-contract.env"
  printf '%s\n' "$content" > "$fixture/$filename"
  (
    cd "$fixture"
    shasum -a 256 artifact-contract.env index.html "$filename" > artifact-manifest.sha256
  )
  if QUARTZ_ARTIFACT="$fixture" "$ROOT/bin/assemble-release" >/dev/null 2>&1; then
    printf 'artifact test: assembly fixture was accepted: %s\n' "$name" >&2
    exit 1
  fi
}

safe="$tmp_dir/safe"
mkdir "$safe"
printf '%s\n' '<!doctype html><html><body><a href="/quartz/docs/">Local navigation</a></body></html>' > "$safe/index.html"
printf '%s\n' 'body { color: black; }' > "$safe/site.css"
"$ROOT/bin/check-artifact-network" "$safe" >/dev/null

expect_network_reject img-double html '<img src="https://evil.example/x.png">'
expect_network_reject img-single html "<img src='https://evil.example/x.png'>"
expect_network_reject img-unquoted html '<img src=https://evil.example/x.png>'
expect_network_reject media html '<video poster="//evil.example/x"><source src=/local></video>'
expect_network_reject iframe-srcdoc html '<iframe srcdoc="<img src=https://evil.example/x>"></iframe>'
expect_network_reject mixed-malformed html '<ImG s r c = h t t p s : / / evil.example/x>'
expect_network_reject encoded-colon html '<img src="https&#58;//evil.example/x">'
expect_network_reject redirect html '<meta http-equiv="refresh" content="0;url=https://evil.example">'
expect_network_reject event-handler html '<a href="/quartz" onClick="fetch(\"//evil.example\")">x</a>'
expect_network_reject external-anchor html '<a href="https://evil.example/">external</a>'
expect_network_reject css-url css 'body{background:url(https://evil.example/x)}'
expect_network_reject css-import css '@IMPORT "//evil.example/x.css";'
expect_network_reject js-fetch js 'fetch("https://evil.example")'
expect_network_reject js-xhr js 'new XMLHttpRequest()'
expect_network_reject js-websocket js 'new WebSocket("wss://evil.example")'
expect_network_reject js-import mjs 'import("https://evil.example/mod.js")'

expect_assembly_reject payload-htm payload.htm '<!doctype html><img src="https://evil.example/x.png">'
expect_assembly_reject payload-xhtml payload.xhtml '<?xml version="1.0"?><html xmlns="http://www.w3.org/1999/xhtml"><body>x</body></html>'
expect_assembly_reject external-svg image.svg '<svg xmlns="http://www.w3.org/2000/svg"><image href="https://evil.example/x.png"/></svg>'
expect_assembly_reject unknown-extension payload.unknown 'plain but unsupported served content'
expect_assembly_reject disguised-html image.png '<!doctype html><script src="https://evil.example/x.js"></script>'

printf '%s\n' '<!doctype html><html lang="en"><head><title>Quartz</title><meta name="description" content="Fixture"><link rel="canonical" href="/quartz"><meta property="og:title" content="Quartz"><meta property="og:description" content="Fixture"><meta property="og:type" content="website"><meta property="og:url" content="/quartz"><meta property="og:image" content="/icon.png"><meta name="twitter:card" content="summary"></head><body><h1>Quartz artifact fixture</h1></body></html>' > "$artifact/index.html"
printf '%s\n' 'ARTIFACT_KIND=quartz-site' 'PUBLIC_BASE=/quartz' 'SOURCE_REVISION=0000000000000000000000000000000000000000' 'VALIDATION_SCOPE=integrity-and-route-contract' 'NETWORK_PROFILE=static-no-external-requests-v1' > "$artifact/artifact-contract.env"
(
  cd "$artifact"
  shasum -a 256 artifact-contract.env index.html > artifact-manifest.sha256
)

QUARTZ_ARTIFACT="$artifact" "$ROOT/bin/assemble-release" >/dev/null
[ -s "$ROOT/dist/quartz/index.html" ]
[ ! -e "$ROOT/dist/quartz/artifact-contract.env" ]
[ ! -e "$ROOT/dist/quartz/artifact-manifest.sha256" ]
"$ROOT/test/routes.sh" >/dev/null

printf '%s\n' 'undeclared' > "$artifact/undeclared.txt"
if QUARTZ_ARTIFACT="$artifact" "$ROOT/bin/assemble-release" >/dev/null 2>&1; then
  printf '%s\n' 'artifact test: incomplete manifest was accepted' >&2
  exit 1
fi
rm "$artifact/undeclared.txt"

if QUARTZ_ARTIFACT="$artifact" "$ROOT/bin/build" >/dev/null 2>&1; then
  printf '%s\n' 'artifact test: core build accepted artifact injection' >&2
  exit 1
fi

"$ROOT/bin/build" >/dev/null
printf '%s\n' 'Quartz artifact integrity and active-network deny-profile tests passed.'
