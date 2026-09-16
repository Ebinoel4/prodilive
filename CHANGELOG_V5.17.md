# v5.17.0 — Fixed reset-password link landing on the homepage

## Root cause
Every emailed link (reset-password, verify-email, payment redirects) was
built as `${APP_URL}/reset-password?token=...` with no cleanup of `APP_URL`.
If `APP_URL` was set with a trailing slash (e.g.
`https://prodilive.com/` instead of `https://prodilive.com`) — an extremely
easy mistake to make — every link came out with a **double slash**:
`https://prodilive.com//reset-password?token=...`. Browsers treat that as
path `//reset-password`, not `/reset-password`, so the page-load check that
looks for "am I on the reset-password page?" never matched, and you landed
on the plain homepage instead.

## Fix
- Added a single normalized `APP_ORIGIN` constant that strips any trailing
  slash from `APP_URL` once, and every link-building spot in the app
  (reset-password, verify-email, welcome email, payment callback, admin
  notification emails, CORS, and the real-time connection) now uses it
  consistently.
- Also relaxed the front-end's own page-detection so it matches even if a
  stray slash sneaks in some other way — belt and suspenders.

## What to check
Double-check your `APP_URL` environment variable on Render is exactly:
```
APP_URL=https://prodilive.com
```
with **no trailing slash**. This fix normalizes it either way, so it'll
work now regardless — but keeping it clean avoids relying on that.

## Deploy steps
Just push — no migration, no other env var changes needed.

After it's live, request another password reset and click the link — it
should open the "Choose a new password" form directly.
