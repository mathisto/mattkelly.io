# Portfolio Decisions

## D001: Canonical Repository

`mattkelly.io` becomes the canonical portfolio source. The current Rails implementation remains in Git history and receives an archival tag before replacement.

## D002: Build and Serving Boundary

Quartz generates the static portfolio offline. Caddy serves ordinary portfolio pages. Copy must not say that Caddy-served requests were served by Quartz.

Soul of Quartz may truthfully state that its HTTP response comes from the Quartz unikernel when the complete request path has been verified and the external TLS, proxy, host, hypervisor, and guest boundaries are shown.

## D003: Public Navigation

Primary navigation is `Work`, `Lab`, `Writing`, and `About`. Resume, References, Now, Provenance, Site History, and Source are secondary destinations.

## D004: Browser Dependencies

The finished portfolio uses semantic HTML, CSS, local assets, and narrowly scoped vanilla JavaScript. Remove jQuery Terminal, Font Awesome, Devicon, Prism CDN, Google Fonts, and request-time GitHub activity.

## D005: Public Telemetry

Public telemetry is optional enhancement content, never a portfolio availability dependency. It must be read-only, allowlisted, delayed or coarsened where appropriate, rate-limited, and safe to replace with an unavailable state.

Exact visitor paths are prohibited. Public controls that spawn, cancel, or amplify work are prohibited unless authenticated and isolated from the portfolio.

## D006: Cloudflare Fallback

Use a tiny self-contained branded outage page at the Cloudflare edge rather than a full mirrored site. It returns `503`, identifies itself as a degraded fallback, does not claim live status, and is not cached after recovery.

## D007: Home Lab Scope

Publish a sanitized logical architecture and operational lessons. Do not publish the private homelab repository or details that materially improve reconnaissance.

Alerting and public-ingress restrictions are in scope. Backup implementation is explicitly deferred and will be described honestly rather than presented as complete.

## D008: Solar

Plan a once-daily local collection job. Credentials remain on a trusted host. Raw responses remain private. Only sanitized daily or monthly aggregates enter the static site.

No environmental claim is published until electrical boundaries, units, coverage, and import/export semantics are verified. Avoid broad `zero footprint`, `carbon neutral`, and `energy negative` wording.

## D009: Local AI

Remove the ESP32 wake-word and voice-assistant prototype from the portfolio roadmap. Do not use it as a featured Lab case.

## D010: References

All currently listed references have explicit publication consent. They may be migrated without a new consent gate, while preserving accurate names, roles, quotations, and links.

## D011: Rails and Scribe

Rails is historical. Scribe remains private and is not migrated into the static portfolio. Private data handling and archival are separate from public content migration.
