# Claim Evidence Records

The canonical public ledger is the build-validated flat file at `site/content/claims.txt`. One record occupies one line:

```text
id|status|claim|source|reviewed_on|reviewer|pages|boundary
```

Approved statuses are `source`, `public`, and `personal-account`. The Quartz build rejects malformed dates, unknown statuses, duplicate or unsafe identifiers, and missing source, review, page, or disclosure fields. `bin/check` also rejects generated `data-claim` references that do not resolve to the ledger.

The ledger records publication authority, not universal truth. `source` is limited to the named immutable repository record. `public` may establish context without proving individual contribution. `personal-account` remains visibly labeled in public copy.
