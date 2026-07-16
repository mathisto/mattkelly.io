#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/mattkelly-evidence-manifest.XXXXXX")
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM
snapshot="$tmp_dir/snapshot"
manifest="$tmp_dir/validated-evidence.manifest"

PORTFOLIO_EVIDENCE_MANIFEST_OUT="$manifest" "$ROOT/bin/validate-content" >/dev/null
mkdir -p "$snapshot/bin" "$snapshot/site/content" "$snapshot/docs/migrations/portfolio/evidence"
cp "$ROOT/bin/validate-content" "$snapshot/bin/validate-content"
cp "$ROOT/toolchain.env" "$snapshot/toolchain.env"
cp "$ROOT/site/content/routes.txt" "$ROOT/site/content/claims.txt" "$snapshot/site/content/"
cp -R "$ROOT/site/content/pages" "$snapshot/site/content/pages"
cp "$ROOT/docs/migrations/portfolio/evidence/phase-0-caddy-2026-07-16.md" "$snapshot/docs/migrations/portfolio/evidence/"
cp "$manifest" "$snapshot/site/content/validated-evidence.manifest"
manifest="$snapshot/site/content/validated-evidence.manifest"
manifest_hash=$(shasum -a 256 "$manifest" | cut -d' ' -f1)

[ ! -e "$snapshot/.git" ]
PORTFOLIO_EVIDENCE_MANIFEST="$manifest" PORTFOLIO_EVIDENCE_MANIFEST_SHA256="$manifest_hash" "$snapshot/bin/validate-content" >/dev/null
"$snapshot/bin/validate-content" --check-operator-evidence-path docs/migrations/portfolio/evidence/phase-0-caddy-2026-07-16.md >/dev/null

for unsafe_path in /etc/hosts docs/migrations/portfolio/evidence/../phase-0-caddy-2026-07-16.md; do
  if "$snapshot/bin/validate-content" --check-operator-evidence-path "$unsafe_path" >/dev/null 2>&1; then
    printf 'evidence manifest: unsafe operator path was accepted: %s\n' "$unsafe_path" >&2
    exit 1
  fi
done
ln -s /etc/hosts "$snapshot/docs/migrations/portfolio/evidence/hosts-link"
if "$snapshot/bin/validate-content" --check-operator-evidence-path docs/migrations/portfolio/evidence/hosts-link >/dev/null 2>&1; then
  printf '%s\n' 'evidence manifest: symlinked operator evidence was accepted' >&2
  exit 1
fi

printf '\n' >> "$snapshot/site/content/claims.txt"
if PORTFOLIO_EVIDENCE_MANIFEST="$manifest" PORTFOLIO_EVIDENCE_MANIFEST_SHA256="$manifest_hash" "$snapshot/bin/validate-content" >/dev/null 2>&1; then
  printf '%s\n' 'evidence manifest: tampered claims were accepted' >&2
  exit 1
fi
cp "$ROOT/site/content/claims.txt" "$snapshot/site/content/claims.txt"
printf '\n' >> "$manifest"
if PORTFOLIO_EVIDENCE_MANIFEST="$manifest" PORTFOLIO_EVIDENCE_MANIFEST_SHA256="$manifest_hash" "$snapshot/bin/validate-content" >/dev/null 2>&1; then
  printf '%s\n' 'evidence manifest: tampered manifest was accepted' >&2
  exit 1
fi

printf '%s\n' 'Git-less evidence snapshot and tamper rejection tests passed.'
