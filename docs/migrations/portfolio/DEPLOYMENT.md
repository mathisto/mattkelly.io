# Portfolio Deployment

This is the durable operator reference for deploying `mattkelly.io`. It records
stable local aliases and filesystem conventions, not credentials or private
network topology.

## Deployment identity

| Setting | Value |
|---|---|
| SSH target | `quartz` |
| SSH target source of truth | `~/projects/linux-hyper/ssh-config/snapshots/lovelace.config` |
| Incoming releases | `/opt/mattkelly/incoming` |
| Deployment root | `/opt/mattkelly` |
| Active document root | `/opt/mattkelly/current/public` |
| Caddy configuration | `/etc/caddy/Caddyfile` |
| Development smoke URL | `https://dev.mattkelly.io` |
| Soul smoke URL | `https://soulofquartz.mattkelly.io` |

The `quartz` alias resolves through the operator's SSH configuration. Do not add
its address, private DNS name, key path, tunnel identifier, token, or credential
to this repository. If the VM moves, update the SSH source of truth while keeping
this deployment alias stable.

## Production sequence

Build and validate a clean `complete` release before starting this sequence.
Replace `<release-directory>` and `<release-id>` with the validated candidate.

```sh
DEPLOY_HOST=quartz \
DEPLOY_INCOMING_ROOT=/opt/mattkelly/incoming \
bin/release-transfer --dry-run <release-directory>

DEPLOY_HOST=quartz \
DEPLOY_INCOMING_ROOT=/opt/mattkelly/incoming \
bin/release-transfer <release-directory>
```

The release tools must be run from the same reviewed portfolio revision that
built the candidate. Install that exact tool snapshot under
`/opt/mattkelly/tools/<portfolio-revision>`, then open an SSH session before
running commands that use `/opt/mattkelly`:

```sh
ssh quartz
cd /opt/mattkelly/tools/<portfolio-revision>

DEPLOY_ROOT=/opt/mattkelly \
bin/release-stage /opt/mattkelly/incoming/<release-id>

DEPLOY_ROOT=/opt/mattkelly \
bin/release-activate <release-id>

SMOKE_BASE_URL=https://dev.mattkelly.io \
SMOKE_RELEASE=/opt/mattkelly/releases/<release-id> \
SOUL_SMOKE_URL=https://soulofquartz.mattkelly.io \
SMOKE_ASSET_CACHE_PATTERN=max-age=14400 \
bin/release-smoke
```

The apex intentionally returns an empty, non-cacheable placeholder while design
refinement is in progress. The immutable release is available only on the `dev`
hostname and is marked `noindex`.

The origin contract is `max-age=3600`. Cloudflare currently rewrites static asset
responses to its reviewed four-hour edge TTL (`max-age=14400`), so public smoke
sets that explicit expectation. Isolated origin previews omit the override and
continue to verify the origin value.

When `ops/caddy/Caddyfile` changes, validate it on `quartz`, install it as
`/etc/caddy/Caddyfile`, and reload Caddy only after the candidate is staged. Public
host addresses, the document root, and the loopback Soul upstream have production
defaults in the Caddyfile, so the stock service requires no hidden environment.
Environment overrides remain available for isolated tests. Preserve the prior
Caddyfile until public verification succeeds.

## Rollback

```sh
ssh quartz
cd /opt/mattkelly/tools/<portfolio-revision>
DEPLOY_ROOT=/opt/mattkelly bin/release-rollback
```

After rollback, run `bin/release-smoke` against the restored release and verify the
public apex, `/quartz`, CV `410` routes, Soul allowlist, and malformed Soul URI
default-deny behavior.

## Live preflight

Before every deployment, verify rather than assume:

```sh
ssh quartz 'systemctl is-active caddy cloudflared'
ssh quartz 'caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile'
```

Also confirm that `/opt/mattkelly` is a real directory, deployment links stay
inside it, the candidate is not already staged, and no deploy lock or interrupted
intent needs operator review.
