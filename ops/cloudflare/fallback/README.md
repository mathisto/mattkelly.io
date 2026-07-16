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
