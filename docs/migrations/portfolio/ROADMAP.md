# Living Portfolio Migration

**Status:** Approved for execution
**Created:** 2026-07-16
**Canonical repository:** `mattkelly.io`

## Purpose

Replace the historical Rails application with a dependency-minimal, Quartz-generated static portfolio that is served from the home lab through Cloudflare Tunnel and Caddy. The site should work as a conventional professional portfolio while rewarding deeper inspection with reproducible evidence about Quartz, the unikernel, the home lab, and the site's own build and deployment.

## Target Architecture

```text
Visitor
  -> Cloudflare edge
  -> outbound Cloudflare Tunnel
  -> Caddy
  -> immutable static release

Optional isolated paths
  -> read-only delayed telemetry
  -> Quartz userspace service
  -> Quartz unikernel
```

The portfolio runtime has no Rails, Ruby, database, application server, background jobs, Node runtime, browser framework, or request-time third-party API dependency. Quartz is a pinned offline build tool. Caddy is the production static HTTP server.

## Hard Rules

1. Preserve the unrelated working-tree change in `app/controllers/scribe/utterances_controller.rb`.
2. Do not expose secrets, private addresses, hostnames, tunnel identifiers, VM identifiers, credential locations, recovery commands, or household activity patterns.
3. Do not publish claims without an evidence record or an explicit personal-account label.
4. Do not deploy, rotate credentials, change DNS, or mutate infrastructure without an attended gate.
5. Do not remove the Rails recovery path until the static site has completed its stabilization window.
6. Do not publish raw solar API responses or credentials.
7. Do not publish exact visitor paths or anonymous resource-amplification controls.
8. Keep the static portfolio available when all dynamic Quartz services are stopped.
9. Validate every release against immutable repository SHAs and an artifact manifest.
10. Preserve historical implementation through Git history and an archival tag rather than compatibility code.

## Approved Decisions

| Decision | Outcome |
| --- | --- |
| Canonical source | Repurpose `mattkelly.io`; preserve Rails in history and an archive tag |
| Serving | Caddy serves static pages; copy states exactly which requests traverse Quartz |
| Quartz content | Keep `/quartz/*` under the apex as a separately versioned artifact |
| Astro | Remove incrementally after Quartz SSG parity |
| DragonRuby | Preserve initially as an archived lab exhibit |
| GitHub heatmap | Remove |
| Terminal | Keep as an accessible evidence navigator |
| References | Publish; consent is already confirmed |
| Analytics | Prefer no browser analytics |
| Voice assistant | Remove from the portfolio plan |
| Rails | Archive after stabilization; do not keep a public Rails origin |
| Dynamic telemetry | Isolated, read-only, delayed, allowlisted, and rate-limited |
| Edge fallback | Tiny branded Cloudflare outage page with explicit degraded-state messaging |
| Home lab backups | Deferred by owner; do not block the migration on backup implementation |
| Home lab alerting | In scope |
| Cloudflare ingress restrictions | In scope |
| Solar | Add once-daily provider ingestion after credentials and API documentation arrive |

## Execution Phases

| Phase | Outcome | Mode | Gate |
| --- | --- | --- | --- |
| 0 | Contain unsafe public Quartz controls and path feed | Quartz source changes serial; edge review attended | No anonymous resource amplification or exact path feed |
| 1 | Freeze routes, content, claims, and current deployment evidence | Research parallel; contracts serial | Every public item has a disposition |
| 2 | Preserve the Rails era and private Scribe data | Serial | Historical restoration path documented |
| 3 | Harden and relocate the Quartz SSG | Core implementation serial; tests parallel | Reproducible clean builds |
| 4 | Migrate Work, Lab, Writing, About, Resume, References, and Site History | Parallel by content family | Every claim resolves to evidence |
| 5 | Build the unified editorial design system | Tokens first, pages parallel afterward | Accessible without JavaScript |
| 6 | Add provenance, build receipts, terminal commands, and proof surfaces | Parallel behind frozen schemas | Source-to-artifact chain is inspectable |
| 7 | Add immutable Caddy releases, alerting, ingress restrictions, and edge fallback | Infrastructure changes serial and attended | Static site survives Quartz service failure |
| 8 | Integrate daily solar ingestion and public aggregates | Adapter after provider handoff | Measurement and privacy gates pass |
| 9 | Validate one pinned cross-repository release tuple | Independent validators parallel | All release thresholds pass |
| 10 | Launch through preview, atomic activation, and rollback rehearsal | Serial and attended | Public smoke suite passes |
| 11 | Observe for 14-30 days | Serial observation | No unresolved high-severity issue |
| 12 | Disable and archive Rails infrastructure | Serial and attended | No public or recovery dependency on Rails |

## Agent Strategy

Use this roadmap as the program-level Saga. Use bounded Conductor runs per phase rather than one unconstrained run across all repositories.

Read-only exploration, content families, and independent validation should run in parallel. Shared schemas, SSG internals, repository integration, infrastructure state, deployment, and cleanup must run serially.

Every implementation task must identify one repository, one isolated worktree, one base SHA, one ownership area, one verification command, and one evidence record. Validation agents inspect immutable integration state and do not repair their own findings.

## Release Thresholds

| Area | Requirement |
| --- | --- |
| Approved routes | 100% covered |
| Broken internal links | 0 |
| Missing assets | 0 |
| Draft leakage | 0 |
| Unsupported claims | 0 |
| Serious accessibility findings | 0 |
| Keyboard blockers | 0 |
| Third-party browser requests | 0 unless explicitly approved |
| Secret scan | 0 findings |
| Reproducible build | Pass |
| Rollback rehearsal | Pass |
| Lighthouse performance | 95+ target |
| Lighthouse accessibility | 100 target |

## Current Work

- Phase 0 endpoint and privacy containment is being specified.
- The Cloudflare degraded fallback is scaffolded under `ops/cloudflare/fallback/`.
- Solar ingestion is blocked only on provider documentation, endpoint details, and credentials.
- The Rails-to-static foundation now lives under `site/`, with a pinned external Quartz compiler contract, deterministic clean build, input validation, and core route/asset smoke checks.
- Astro remains an external transitional producer for the separately assembled `/quartz` artifact and is not required by the core portfolio build.
- Content evidence review, the complete editorial redesign, immutable Caddy release wiring, and attended deployment remain future phases.
