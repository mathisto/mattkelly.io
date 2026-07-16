# Cloudflare Phase 0 Rules

These rules are defense in depth for the source-level Quartz containment patch. Apply through an attended change after confirming the current zone plan and testing on a preview hostname.

**Implementation status:** specification only. This repository does not demonstrate that any Cloudflare tunnel ingress, WAF, rate-limit, cache, Access, or Custom Error Rule is installed.

## Public Host Allowlist

The tunnel ingress should route only explicitly approved public hostnames. Unknown hostnames must terminate with a non-origin response rather than falling through to Caddy or another internal service.

Approved public roles:

- Apex portfolio
- `www` redirect
- Quartz redirect, if retained
- Soul of Quartz demonstration

Do not use a wildcard public ingress rule. Do not expose internal vanity hosts, admin tools, observability, hypervisor interfaces, or private service names through the public tunnel.

The ingress policy must be an ordered hostname allowlist followed by an explicit default deny, for example:

```yaml
ingress:
  - hostname: <approved-apex>
    service: <operator-managed-caddy-service>
  - hostname: <approved-www-redirect-host>
    service: <operator-managed-caddy-service>
  - hostname: <approved-soul-host>
    service: <operator-managed-caddy-service>
  - service: http_status:404
```

Place private service URLs in the tunnel's managed runtime configuration, not in this repository. Before an attended apply, export the active configuration through the approved secret-safe process, compare the hostname set, validate the configuration, and test an unrecognized hostname. A default service that proxies to an origin is not a deny rule.

## Block Retired Controls

Block these paths at the edge even after source removal:

```text
/load
/load/*
/api/recent.json
/api/stats.json
/api/host.json
/api/soul/tasks.json
/api/soul/spawn
/api/soul/cancel
/api/soul/demo/*
```

Return `404` for retired routes rather than advertising their former function. Cloudflare Access may be used instead if an operator-only control surface is restored later.

## Public Read-Only Routes

The intended anonymous dynamic surface is:

```text
mattkelly.io/api/info
soulofquartz.mattkelly.io/api/soul/stats.json
soulofquartz.mattkelly.io/health
```

Restrict API methods to `GET`. The Quartz userspace source also rejects unsupported methods.

## Rate Limits

Initial conservative limits:

| Route | Suggested per-client limit | Cache |
| --- | --- | --- |
| `/api/info` | 30 requests/minute | Edge cache 60 seconds |
| `/api/soul/stats.json` | 30 requests/minute | Edge cache 5 seconds |
| `/health` | Exempt known monitor; 60 requests/minute otherwise | No cache or very short cache |

The Soul page polls every five seconds, requiring approximately 12 requests per minute before edge caching. Revisit thresholds using aggregate Cloudflare metrics, not public visitor logs.

Rate-limit responses should be JSON for APIs, return `429`, and include `Retry-After`. Do not redirect API clients to an HTML challenge page unless deliberate browser-only access is required.

## Fallback

Apply the branded fallback from `ops/cloudflare/fallback/index.html` only to HTML navigation failures caused by an unreachable origin or tunnel. Do not replace API errors, normal 404s, security responses, or optional Quartz-service failures with the site-wide fallback.

## Verification

1. Confirm unknown tunnel hostnames do not reach any origin.
2. Confirm all retired paths return 404 without touching Quartz.
3. Confirm only GET reaches retained APIs.
4. Confirm the Soul page works at the configured rate and cache policy.
5. Confirm stopping Quartz leaves static portfolio pages normal.
6. Confirm stopping Caddy or the tunnel returns the branded 503 fallback.
7. Confirm recovery removes the fallback immediately.
8. Confirm no response or log exposes internal hostnames, addresses, or credentials.

Record dated evidence for each result and the Cloudflare change identifier without recording tunnel tokens, account identifiers, origin addresses, or private service names. A successful local Caddy test is not evidence that edge rules are installed.
