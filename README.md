# mattkelly.io

Canonical source for Matt Kelly's dependency-minimal static portfolio. Rails is preserved in Git history and `rails-final-2026-07-16`; it is not part of the build.

## Core Build

The verified profile is currently macOS arm64 with exact Quartz and Homebrew LLVM binaries pinned in `toolchain.env`:

```sh
QUARTZ_CHECKOUT=/path/to/clean-pinned-quartz ./bin/build
QUARTZ_CHECKOUT=/path/to/clean-pinned-quartz ./bin/verify
```

This profile is reproducible on the validated host, not yet claimed portable across operating systems or package-manager builds.

## Release Assembly

`/quartz` is a separately produced artifact and is required for a complete release:

```sh
QUARTZ_CHECKOUT=/path/to/clean-pinned-quartz \
QUARTZ_ARTIFACT=/path/to/quartz-artifact \
./bin/assemble-release
```

Artifact validation checks integrity and route contract, not security. See `docs/migrations/portfolio/STATIC_ARCHITECTURE.md`.

## Structure

- `site/`: static portfolio source and Quartz SSG
- `test/`: content, output, and route validation
- `ops/caddy/`: frozen serving and redirect contract
- `docs/migrations/portfolio/`: decisions, disposition ledger, and evidence placeholders
- `dragonruby/` and `public/dragonruby/`: preserved archive excluded from the core release
- `dist/`: ignored deterministic output

CV downloads are intentionally withheld until privacy-safe PDF and DOCX files are generated and reviewed.
