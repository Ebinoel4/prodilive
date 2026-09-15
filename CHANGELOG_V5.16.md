# v5.16.0 — Homepage privacy fix + a much bigger bug it uncovered

## What you asked for: homepage summary stats instead of specific job details
Fixed. The homepage no longer broadcasts a toast like "New project posted:
Fix my vocal take" to every visitor the moment any client posts a job —
that was happening site-wide, to anyone sitting on the homepage, logged in
or not.

Replaced with a stats strip under the hero showing:
- Projects posted today
- Open projects right now
- Active users
- Projects completed

These come from a new public endpoint (`/api/stats/public`) and tick up
live via the same real-time connection, without ever naming a specific
client or job. The detailed live list (with real titles) still appears on
the actual **jobs/browse page** — that's the real marketplace providers use
to find and claim work, so it still needs full detail there. Only the
homepage was over-sharing.

## The bigger thing this uncovered
While tracing that, I found that **`/api/talents` required being logged in
— meaning your entire "Find Talent" page, and every individual provider's
public profile (with the portfolio feature from last round), silently
failed for anyone who wasn't already signed in.** A prospective client
couldn't actually check someone's page before trusting them with a job —
the exact workflow you asked me to support — because the page never loaded
without an account.

Also affected: a provider's reviews and service listings on their public
profile, and the jobs/browse page (same issue, slightly different fix
since it also needs to show a logged-in client their own jobs).

**Fixed:**
- `/api/talents` — now public, no login required
- `/api/talents/:id/services` — now public
- `/api/talents/:id/reviews` — now public
- `/api/jobs` — now works for anonymous visitors (shows only OPEN jobs);
  logged-in users still see their own jobs mixed in as before

This means anonymous visitors can now actually browse providers, view
portfolios, and check reviews before ever creating an account — which is
the whole point of the portfolio feature and the general "let clients vet
providers first" goal.

## Deploy steps
Just push — no new migration, no env var changes.
