# External Alerting Specification

This is a provider-neutral specification for monitoring from outside the origin network. No monitors are claimed to be installed.

## Apex checks

| Check | Request | Success | Frequency | Alert policy |
| --- | --- | --- | --- | --- |
| Homepage | `GET https://<apex>/` | `200`, TLS valid, body contains the release's stable page marker | 60 seconds | Alert after 3 consecutive failures; resolve after 2 successes |
| Static asset | `GET https://<apex>/assets/css/site.css` | `200`, non-empty, expected bounded cache header | 5 minutes | Alert after 2 failures |
| Canonical redirect | `GET https://<apex>/projects` without following redirects | `308` to `/projects/` | 15 minutes | Alert after 2 failures |
| Quartz artifact | `GET https://<apex>/quartz` | `200` for complete production releases | 5 minutes | Alert after 2 failures; omit on declared core-only previews |

Run from at least two independent regions. Alert on TLS expiry at 30, 14, and 7 days. Keep response capture free of cookies and personal data.

## Soul checks

| Check | Request | Success | Frequency | Alert policy |
| --- | --- | --- | --- | --- |
| Soul health | `GET https://<soul-host>/health` | `200`, expected bounded health payload, latency below agreed threshold | 60 seconds | Warning after 2 failures, critical after 5 |
| Soul read-only API | `GET https://<soul-host>/api/soul/stats.json` | `200`, valid JSON, expected public keys only | 5 minutes | Alert after 2 failures |

Never use mutation, demo, load, cancellation, task-list, host-detail, or retired routes as health checks. Soul alerts are separate from apex alerts: Soul degradation must not page as an apex static-site outage.

## Routing and ownership

- Route critical apex failures to the primary operations channel.
- Route Soul-only failures to its service owner with lower initial severity.
- Include status, observed redirect, region, latency, and timestamp; do not include private origin topology.
- Add a maintenance window before an attended activation and require a post-activation smoke result before closing it.
- Test notification delivery and escalation quarterly.
