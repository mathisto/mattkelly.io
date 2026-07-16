# Cloudflare Degraded Fallback

This self-contained page is intended for a narrowly scoped Cloudflare Custom Error Rule. It is not part of the normal site artifact and does not mirror portfolio content.

Recommended response behavior:

```http
HTTP/1.1 503 Service Unavailable
Cache-Control: no-store, max-age=0
Retry-After: 60
X-Robots-Tag: noindex, nofollow
Content-Type: text/html; charset=utf-8
X-Mattkelly-Fallback: cloudflare-edge
```

Apply only to HTML `GET` and `HEAD` requests for origin connectivity failures. Do not replace normal `404`, `403`, `429`, API responses, or failures limited to optional Quartz services.

Test through a staging hostname before enabling the rule on the apex. Verify that stopping only the Quartz dynamic service leaves static pages normal, while stopping Caddy or the tunnel produces this page and recovery is immediate after restart.

## Attended deployment and test

No fallback rule is claimed to be installed. Use this sequence with a provider-supported preview hostname and an approved maintenance window:

1. Create the custom error response from `index.html` and the headers above without attaching it to production traffic.
2. Scope a preview rule to HTML `GET` and `HEAD` requests and origin connectivity failures only.
3. Request a normal preview page, a missing page, a rate-limited test response, and an API response. The fallback must not replace any of them.
4. Make only the preview origin unreachable. Confirm the response is `503`, includes `Retry-After`, `no-store`, `X-Robots-Tag`, and `X-Mattkelly-Fallback`, and contains no private topology.
5. Restore the preview origin and confirm the normal response returns immediately without a cached fallback.
6. Make the preview Soul upstream unavailable while keeping Caddy available. Confirm apex static pages do not show the fallback and Soul reports its own failure.
7. Review edge analytics for accidental broad matching, then attach to the apex only through a separate attended and reversible change.

Do not test by stopping the live tunnel or origin before the preview sequence has passed. Keep the last known-good rule definition available for immediate rule rollback.
