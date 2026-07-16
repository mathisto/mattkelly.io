# Phase 0: Public Quartz Safety

## Why This Is First

The current Quartz demonstrations expose shared mutable state and expensive operations to anonymous visitors. Cloudflare Tunnel hides the origin address but does not authenticate these routes or make them inexpensive.

## Hosted Quartz Controls

The Caddy mirror proxies `/load`, `/load/*`, and `/api/*` to the Quartz userspace server.

| Route | Current effect | Disposition |
| --- | --- | --- |
| `/api/info` | Returns server metadata | Retain with coarse information |
| `/load` | Public dashboard for global load controls | Remove from public routing or protect with Cloudflare Access |
| `/load/metrics` | Returns metrics and also creates missing target tasks | Make strictly read-only and protect |
| `/load/set?n=N` | Requests a global target as high as millions of tasks | Protect immediately; remove anonymous access |
| `/load/work?n=N` | Raises shared CPU work per task | Protect immediately; remove anonymous access |
| `/load/stop` | Stops every visitor's shared workload | Protect immediately |

The handler dispatches by path without enforcing HTTP methods, so changing `GET` to `POST` at the UI alone is not sufficient.

## Soul Controls

| Route | Current effect | Disposition |
| --- | --- | --- |
| `/api/soul/spawn?n=N` | Spawns tasks from the shared thin-task pool | Protect; add a small hard cap even when authenticated |
| `/api/soul/cancel` | Cancels all shared demo tasks | Protect |
| `/api/soul/demo/deadline` | Runs a shared-state deadline experiment | Serialize and rate-limit, or protect |
| `/api/soul/demo/cascade?n=N` | Spawns and cancels thousands of tasks | Protect or strictly cap and serialize |
| `/api/soul/demo/race?n=N` | Runs a shared global race experiment | Serialize and rate-limit |
| `/api/soul/demo/restart` | Runs a shared restart simulation | Serialize and rate-limit |

## Recent Request Feed

`/api/recent.json` records the last 64 visitor request paths, statuses, and ticks and republishes them to every visitor. It does not include query strings or IP addresses, but paths can still contain usernames, identifiers, filenames, reset tokens, or accidental secrets.

Replace it with coarse aggregates such as:

```json
{
  "window_seconds": 300,
  "requests": 42,
  "route_classes": {
    "site": 18,
    "docs": 12,
    "demo": 7,
    "health": 5
  },
  "status_classes": {
    "2xx": 40,
    "4xx": 2,
    "5xx": 0
  }
}
```

No exact path, source address, user agent, referrer, or recent-event stream should be public.

## Public Statistics

Retain a small proof surface:

- Coarse uptime
- Current live-task range or bucket
- Total spawn and exit counters
- Coarse guest memory percentage
- Aggregate request rate
- Build/release identity

Remove or keep private:

- MAC address
- Internal device identity
- LAPIC identifiers
- WireGuard identity unless intentionally demonstrated
- Exact allocator internals
- Exact task IDs
- Recent paths
- Exact host capacity and restart policy

## Implementation Order

1. Confirm installed Caddy and Cloudflare route exposure without calling mutation endpoints.
2. Add edge containment for `/load/*` and Soul mutation routes.
3. Add explicit method enforcement in Quartz handlers.
4. Make read-only endpoints actually read-only.
5. Replace exact recent paths with coarse counters.
6. Add source-level hard caps and serialization.
7. Reduce polling frequency.
8. Add edge and source rate limits.
9. Verify static portfolio availability with dynamic services stopped.
10. Run an adversarial endpoint review before restoring any public control.

## Acceptance Criteria

- Anonymous requests cannot spawn, cancel, or amplify shared work.
- Unsupported methods do not mutate state.
- Metrics endpoints perform bounded work.
- No public endpoint reveals exact visitor paths.
- Public telemetry contains only allowlisted fields.
- Dynamic service failure does not affect static portfolio pages.
