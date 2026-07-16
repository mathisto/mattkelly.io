# Content And Asset Disposition

This ledger freezes the foundation migration state. `Preserved` does not mean independently verified; claim evidence state is listed separately.

| Source | Static destination | Disposition | Validation / evidence state |
| --- | --- | --- | --- |
| Rails home, projects, and CV views | `site/content/pages/` | Adapted | Biographical and accomplishment claims are visibly labeled personal accounts; independent evidence pending |
| Five reference cards | `site/content/pages/references.html` | Migrated with confirmed publication consent | Quotations and attribution transcribed from Rails source; source snapshot is Git history |
| Five reference JPEGs | `site/public/images/references/` | Byte-preserved | JPEG type and pinned SHA-256 validated |
| Tokyo Night blog cover | `site/public/images/blog/` | Byte-preserved | PNG type and pinned SHA-256 validated |
| Favicons and site icons | `site/public/` | Byte-preserved | ICO/PNG/SVG type, SVG parse, and pinned SHA-256 validated |
| Rails PDF CV | None | Withheld | PDF structure passed `pdfinfo`; configured privacy scan detected sensitive contact data |
| Rails DOCX CV | None | Withheld | ZIP integrity passed; no public pair is shipped until both formats are deliberately redacted and reviewed |
| Published `building-mattkelly-io` post | `site/content/blog/` | Migrated as historical personal account | Frontmatter and output validated; detailed claims not independently verified |
| `hello-world` post | Redirect contract only | Retired | Caddy and static tombstone point to the canonical historical article |
| DragonRuby tutorial Markdown | `dragonruby/` | Preserved archive | Not rendered by the core site |
| DragonRuby browser artifacts | `public/dragonruby/` | Preserved archive | Excluded from `dist`; execution, provenance, licensing, and required headers are not verified |
| Quartz Astro site | External `/quartz` artifact | Separately assembled | Requires contract, complete SHA-256 inventory, and active-content-free network profile; conformance is not a general security attestation |
| Rails/Scribe application and data | Git history / private archival process | Not migrated | Private Scribe data is out of portfolio scope |

## Evidence Placeholders

Foundation pages intentionally use personal-account labels. Before removing those labels, add an evidence record under `docs/migrations/portfolio/evidence/` containing the claim, source, capture date, repository revision where applicable, publication constraints, and reviewer.

## Canonical Scribe Change

The canonical worktree has an unrelated modification at `app/controllers/scribe/utterances_controller.rb` with working-file blob `4e4123a503df4c939fb725b6bcc0aaf273f45610`. It remains untouched by this migration. Before final Rails archival, the owner must preserve that change in an appropriate private Rails/Scribe history or explicitly decide its disposition; it must not be silently discarded or copied into the public static repository.
