# Phase 0 Caddy Containment Operator Record

- Performed: 2026-07-16
- Recorded by: Matt Kelly
- Evidence class: operator self-attestation
- Scope: live Caddy public-ingress routing for the Soul hostname

The operator reports that the live Caddy configuration was updated and observed to proxy only exact `GET` and `HEAD` requests for `/health` and `/api/soul/stats.json`. Requests for retired mutation, task, demo, load, detailed telemetry, path-suffix, and otherwise unlisted routes were observed to fail closed rather than reach the Soul upstream.

This record supports only the statement that Phase 0 containment was active at the live Caddy ingress on 2026-07-16. It is not independent evidence, does not attest to Cloudflare rule installation, and does not claim that this source tree or an immutable release produced from it has been deployed. The portfolio serving architecture and optional Quartz demonstrations remain planned or target-state descriptions until separate deployment evidence is recorded.

No hostname, origin address, tunnel identifier, service identifier, credential, account identifier, or private topology is recorded here.
