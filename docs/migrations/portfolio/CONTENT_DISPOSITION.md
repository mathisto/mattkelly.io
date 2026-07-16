# Content And Asset Disposition

This ledger freezes the foundation migration state. `Preserved` does not mean independently verified; claim evidence state is listed separately.

| Source | Static destination | Disposition | Validation / evidence state |
| --- | --- | --- | --- |
| Rails home, projects, and CV views | `/`, `/work/*`, `/about/`, `/resume/` | Adapted into living-resume content | Professional outcomes remain visibly labeled personal accounts in the validated claim ledger |
| Five reference cards | `site/content/pages/references.html` | Migrated with confirmed publication consent | Quotations and attribution transcribed from Rails source; source snapshot is Git history |
| Five reference JPEGs | `site/public/images/references/` | Byte-preserved | JPEG type and pinned SHA-256 validated |
| Tokyo Night blog cover | `site/public/images/blog/` | Byte-preserved | PNG type and pinned SHA-256 validated |
| Favicons and site icons | `site/public/` | Byte-preserved | ICO/PNG/SVG type, SVG parse, and pinned SHA-256 validated |
| Rails PDF CV | None | Withheld | PDF structure passed `pdfinfo`; configured privacy scan detected sensitive contact data |
| Rails DOCX CV | None | Withheld | ZIP integrity passed; no public pair is shipped until both formats are deliberately redacted and reviewed |
| Published `building-mattkelly-io` post | `site/content/blog/` | Migrated as historical personal account | Frontmatter and output validated; detailed claims not independently verified |
| `hello-world` post | Redirect contract only | Retired | Caddy and static tombstone point to the canonical historical article |
| DragonRuby tutorial Markdown | `dragonruby/` and `/lab/dragonruby/` | Preserved archive with public disposition page | Every historical `/dragonruby/:slug` request is permanently redirected to `/lab/dragonruby/`; lessons are not rendered by the core site |
| DragonRuby browser artifacts | `public/dragonruby/` | Preserved archive | Excluded from `dist`; execution, provenance, licensing, and required headers are not verified |
| Quartz Astro site | External `/quartz` artifact | Separately assembled | Requires contract, complete SHA-256 inventory, and active-content-free network profile; conformance is not a general security attestation |
| Rails/Scribe application and data | Git history / private archival process | Not migrated | Private Scribe data is out of portfolio scope |

## Evidence Ledger

`site/content/claims.txt` contains the canonical flat claim records. The build validates record shape and state; output checks validate that page-level claim references resolve. Removing a personal-account label requires a reviewed source record and corresponding copy change.

## Canonical Scribe Change

The canonical worktree has an unrelated modification at `app/controllers/scribe/utterances_controller.rb` with working-file blob `4e4123a503df4c939fb725b6bcc0aaf273f45610`. It remains untouched by this migration. Before final Rails archival, the owner must preserve that change in an appropriate private Rails/Scribe history or explicitly decide its disposition; it must not be silently discarded or copied into the public static repository.
