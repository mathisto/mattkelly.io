# Solar Data Workstream

**Status:** Waiting for provider documentation and credentials

## Goal

Collect the previous closed local day's solar and grid measurements once daily, preserve private source evidence locally, and publish delayed sanitized aggregates that can support narrowly worded energy claims.

## Boundary

```text
On-site solar API
  -> trusted local collector
  -> private raw response archive
  -> canonical local observations
  -> validation and daily/monthly aggregation
  -> sanitized public JSON
  -> static portfolio release
```

Credentials and provider endpoints never enter the portfolio source, generated site, browser, or public telemetry.

## Schedule

- Use a hardened systemd oneshot service and timer rather than application runtime scheduling.
- Run once daily after the provider has finalized the prior local day.
- Use `Persistent=true` so a missed run is recovered after reboot.
- Re-fetch a short reconciliation window when the provider allows range requests.
- Reserve at least 20 percent of the monthly call allowance for retries and diagnostics.
- Never retry authentication failures automatically.

## Canonical Measurements

Store nonnegative directional integer watt-hours:

- `production_wh`
- `consumption_wh`
- `grid_import_wh`
- `grid_export_wh`
- `battery_charge_wh`, if applicable
- `battery_discharge_wh`, if applicable

Do not store import and export as one signed net value. Do not derive consumption or self-consumption until meter boundaries and battery behavior are understood.

## Public Data

Publish versioned static files such as:

```text
/data/solar/v1/index.json
/data/solar/v1/daily/2026.json
/data/solar/v1/monthly.json
/data/solar/v1/methodology.json
```

Default privacy policy:

- At least a two-day publication lag
- Daily production and export only after privacy review
- Consumption and import monthly-only by default
- No interval or real-time household data
- No serial numbers, site IDs, gateway identity, endpoint URL, account metadata, or raw payload hashes
- Missing data is `missing`, never zero
- Partial data is visibly partial
- Failed ingestion leaves the previous public artifact unchanged

## Claim Gates

Before publishing a claim:

1. Confirm API field meanings, units, signs, intervals, and timezone.
2. Confirm the physical boundary of every meter.
3. Capture private fixtures for normal, missing, corrected, and daylight-saving days.
4. Reconcile at least 30 representative days against the provider dashboard.
5. Reconcile monthly grid values with utility data when boundaries align.
6. Document meter precision and acceptable discrepancy.
7. Complete 30 scheduled runs without unexplained duplication or data loss.
8. Pass the public-data allowlist and privacy scan.

Preferred eventual wording:

> During the measured period, on-site generation attributable under the published methodology exceeded the directly metered electricity consumed by the listed home-lab equipment.

## Provider Handoff

When access is available, collect:

- Official API documentation
- Authentication and rotation method
- Read-only credential scope
- Monthly and burst limits
- Historical retention and correction behavior
- Maximum range per request
- Pagination behavior
- Timestamp and timezone semantics
- Native units and precision
- Production, consumption, import, export, and battery field definitions
- Meter reset/replacement behavior
- Representative sanitized payloads
- Desired public metric set

Do not place credentials in chat-visible plans, Git, command-line arguments, generated files, or logs.
