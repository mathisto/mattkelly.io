# Static Portfolio Foundation

## Ownership

`mattkelly.io` owns content, layouts, local assets, and the small SSG under `site/`. The Quartz repository owns the compiler and standard library. Compiler source is not copied here.

## Verified Host Profile

The current release profile is deliberately narrow: macOS arm64, the pinned Quartz checkout/compiler, and the pinned Homebrew LLVM 21.1.8 `llc` and `clang` binaries recorded in `toolchain.env`. This is not yet a portable cross-platform build claim. A different OS, architecture, package-manager build, or LLVM patch requires a reviewed manifest profile and reproduced output.

Release-verifiable core build:

```sh
QUARTZ_CHECKOUT=/path/to/clean-pinned-quartz ./bin/build
```

The checkout must be at the pinned commit/tree and clean, and compiler/`llc`/`clang` hashes must match. `PORTFOLIO_DEV_ALLOW_DIRTY_QUARTZ=1` is an explicitly development-only escape hatch; output produced with it is not release-verifiable.

## Quartz Artifact Contract

The core build never accepts artifact injection. Release assembly requires a separate artifact:

```sh
QUARTZ_CHECKOUT=/path/to/clean-pinned-quartz \
QUARTZ_ARTIFACT=/path/to/validated-quartz-artifact \
./bin/assemble-release
```

The artifact must contain `index.html`, `artifact-contract.env`, no symlinks, and a complete `artifact-manifest.sha256`. Its contract must declare `ARTIFACT_KIND=quartz-site`, `PUBLIC_BASE=/quartz`, a full source SHA, `VALIDATION_SCOPE=integrity-and-route-contract`, and `NETWORK_PROFILE=static-no-external-requests-v1`.

The current network profile is deliberately restrictive rather than a general-purpose sanitizer. Every served file must match an allowlisted extension and detected MIME type. Only `.html`, request-free `.css`, and validated raster image formats are supported; JavaScript, HTM, XHTML, SVG, unknown extensions, and extension/content mismatches are rejected. HTML and CSS then pass the narrow request-surface checks. Contract and manifest controls are verified but removed from the served release. External anchors are also rejected in v1; supporting them requires a future parser-backed profile. These checks establish integrity and conformance to this narrow served-file profile, not broad application security.

Published Markdown bodies are escaped for `&`, `<`, and `>` before Markdown rendering. This makes renderer-created formatting tags the only tags that can reach article output, independent of malformed backticks, escapes, or raw-HTML parsing differences. A post-render entity canonicalization preserves visible angle brackets inside renderer-owned code elements without turning them into markup.

Markdown link destinations use a separate fail-closed grammar before rendering. It permits safe root-relative paths, fragments, lowercase `http://` and `https://` URLs with valid hosts, and simple `mailto:` addresses. Relative paths, protocol-relative URLs, unapproved or mixed-case schemes, whitespace/control characters, percent/entity encoding, backslashes, traversal, malformed hosts/ports, and attribute delimiters are rejected. Approved destinations are contextually escaped before the renderer creates `href` attributes.

Astro remains an allowed transitional external producer, but is not required to build the core and has no compiler ownership here.

## Serving Contract

`ops/caddy/Caddyfile` freezes public URL behavior. Slashless historical portfolio routes redirect with `308` to trailing-slash static routes. `/quartz` is the canonical apex and rewrites internally to the separately assembled artifact; `/quartz/` redirects to `/quartz`. The retired `hello-world` forms redirect to `/blog/building-mattkelly-io/`. Withheld CV download URLs return `410`.

## Validation

```sh
QUARTZ_CHECKOUT=/path/to/clean-pinned-quartz ./bin/verify
```

Validation covers strict frontmatter and escaping fixtures, local asset hashes/types, generated metadata/routes/links/assets, sitemap, robots, 404 behavior, deterministic output, and live Caddy route checks. PDF/DOCX tools are only required when those formats are present; no CV downloads are currently shipped.
