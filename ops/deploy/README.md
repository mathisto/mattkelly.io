# Deployment Runbook

This runbook defines the reviewable deployment path. It does not install Caddy, Cloudflare rules, monitors, credentials, hostnames, or infrastructure.

## Layout and invariants

The serving root is `PORTFOLIO_ROOT=/opt/mattkelly/current/public` by default.

```text
/opt/mattkelly/
  releases/<release-id>/
    public/
    release-files.sha256
    release-manifest.env
  current -> releases/<release-id>
  previous -> releases/<release-id>
```

- A release directory is immutable after staging.
- `current` changes by a same-directory symlink rename, so the old site remains served until activation.
- Production activation accepts only a clean `complete` release with passed core validation and a separately validated `/quartz` artifact.
- `current` and `previous` are never pruning candidates.
- Stage, activation, rollback, and executable pruning serialize through `/opt/mattkelly/.deploy.lock`.
- Manifests contain public build identity and hashes, not hostnames, addresses, credentials, filesystem topology, or tunnel identifiers.

## Build profiles

A complete production release requires the pinned core toolchain and the separately produced Quartz artifact contract:

```sh
QUARTZ_CHECKOUT=/path/to/clean-pinned-quartz \
QUARTZ_ARTIFACT=/path/to/validated-quartz-artifact \
bin/release-build /absolute/output/20260716T120000Z-9a4f54c
```

`bin/release-build` runs the existing reproducible core verification first, then validates and assembles the external `/quartz` artifact. It refuses a dirty repository because `REPOSITORY_SHA` must identify the built source exactly.

A core-only artifact is for an isolated preview, never production:

```sh
RELEASE_ALLOW_DIRTY_PREVIEW=1 \
QUARTZ_CHECKOUT=/path/to/clean-pinned-quartz \
bin/release-build --core-only-preview /absolute/output/preview-9a4f54c
```

The dirty override is optional and deliberately limited to the preview profile. A preview manifest records `quartz:not-included`, and `/quartz` must return `404` while `/quartz/` retains its canonical `308` redirect.

## Transfer, stage, and activate

Use deployment-specific host and incoming paths supplied by the operator; do not put them in a manifest or this repository.

```sh
DEPLOY_HOST=operator-supplied-host \
DEPLOY_INCOMING_ROOT=/operator/supplied/incoming \
bin/release-transfer --dry-run /absolute/output/20260716T120000Z-9a4f54c

DEPLOY_HOST=operator-supplied-host \
DEPLOY_INCOMING_ROOT=/operator/supplied/incoming \
bin/release-transfer /absolute/output/20260716T120000Z-9a4f54c
```

On the destination host, review and run:

```sh
DEPLOY_ROOT=/opt/mattkelly bin/release-stage /operator/supplied/incoming/20260716T120000Z-9a4f54c
DEPLOY_ROOT=/opt/mattkelly bin/release-activate 20260716T120000Z-9a4f54c
SMOKE_BASE_URL=https://operator-supplied-preview-or-apex \
SMOKE_RELEASE=/opt/mattkelly/releases/20260716T120000Z-9a4f54c \
bin/release-smoke
```

Stage verifies hashes in a same-filesystem temporary directory, moves the inactive release under `releases/`, and removes all write bits. Activation does not reload Caddy because Caddy follows `current`; validate and reload Caddy separately only when its configuration changes.

If an interrupted process leaves `.deploy.lock`, first confirm no deployment command is running and inspect `current`, `previous`, and any dot-prefixed staging path. Remove only the stale lock after that review; never automate stale-lock deletion.

For a core-only preview, use a non-production root and the explicit flag:

```sh
DEPLOY_ROOT=/srv/mattkelly-preview bin/release-activate --allow-core-preview preview-9a4f54c
```

## Rollback and pruning

Rollback atomically exchanges `current` and `previous`; it does not delete either release:

```sh
DEPLOY_ROOT=/opt/mattkelly bin/release-rollback
SMOKE_BASE_URL=https://operator-supplied-apex \
SMOKE_RELEASE=/opt/mattkelly/releases/operator-confirmed-restored-release-id \
bin/release-smoke
```

Pruning is a dry run unless `--execute` is present. Release IDs should begin with a sortable UTC timestamp because pruning retains the lexically newest IDs.

```sh
DEPLOY_ROOT=/opt/mattkelly RELEASE_KEEP=5 bin/release-prune
DEPLOY_ROOT=/opt/mattkelly RELEASE_KEEP=5 bin/release-prune --execute
```

## Preview and rollback rehearsal

`SMOKE_RESOLVE=hostname:port:address` makes `curl` target a preview origin without DNS changes. Smoke requests are GET-only and do not invoke Soul mutation routes.

```sh
SMOKE_BASE_URL=https://preview.example.invalid \
SMOKE_RESOLVE=preview.example.invalid:443:127.0.0.1 \
SMOKE_RELEASE=/srv/mattkelly-preview/current \
bin/release-smoke

DEPLOY_ROOT=/srv/mattkelly-rehearsal \
SMOKE_BASE_URL=http://127.0.0.1:18080 \
bin/release-rehearse-rollback /releases/known-good /releases/candidate
```

The rehearsal command refuses `/opt/mattkelly`, stages both inputs, activates the candidate, optionally smokes it, rolls back, optionally smokes the restored release, and verifies both links. `ops/deploy/simulate-local.sh` creates disposable fixtures and exercises the same path.

## Caddy configuration

Supply all values at validation and runtime:

```sh
PORTFOLIO_ADDRESS=https://public-hostname.example \
SOUL_ADDRESS=https://soul-hostname.example \
SOUL_UPSTREAM=http://operator-supplied-upstream \
caddy validate --config ops/caddy/Caddyfile --adapter caddyfile
```

The apex block serves files only. Soul is isolated in a separate site block, blocks known retired controls, and rejects non-GET/HEAD methods before proxying. Keep the upstream private value in service configuration, not source control.
