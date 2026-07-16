#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/mattkelly-content-security.XXXXXX")
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM

expect_reject() {
  name=$1
  content=$2
  fixture="$tmp_dir/$name.html"
  printf '%s\n' "$content" > "$fixture"
  if "$ROOT/bin/validate-content" "$fixture" >/dev/null 2>&1; then
    printf 'content security: accepted unsafe fixture %s\n' "$name" >&2
    exit 1
  fi
}

printf '%s\n' '<main><h1>Safe</h1><p><a href="/work/">Local</a></p></main>' > "$tmp_dir/safe.html"
"$ROOT/bin/validate-content" "$tmp_dir/safe.html" >/dev/null
expect_reject script '<main><script>alert(1)</script></main>'
expect_reject event '<main><p onclick="alert(1)">x</p></main>'
expect_reject iframe '<main><iframe src="/work/"></iframe></main>'
expect_reject srcdoc '<main><p srcdoc="&lt;script&gt;x&lt;/script&gt;">x</p></main>'
expect_reject form '<main><form action="/work/"><input></form></main>'
expect_reject javascript-url '<main><a href="jav&#x61;script:alert(1)">x</a></main>'
expect_reject protocol-relative '<main><img src="//evil.example/x.png" alt="x"></main>'
expect_reject data-url '<main><img src="data:image/svg+xml,x" alt="x"></main>'
expect_reject malformed-nesting '<main><p>x</main></p>'
printf '%s\n' 'Semantic HTML malicious-fragment rejection tests passed.'
