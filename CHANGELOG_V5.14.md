# v5.14.0 — Provider portfolios (minimum 2 pieces)

## What changed
- **Provider dashboard**: new "Portfolio" section (under Profile, above
  Payout details) where a provider adds work samples — each with a title,
  a link (SoundCloud, YouTube, Drive, wherever the work lives), and an
  optional description. The form starts with 2 rows and won't save unless
  at least 2 are filled in with both a title and a link.
- **Public provider profile page** (what a client sees when they click into
  someone from "Find Talent" or before hiring): now shows a "Portfolio"
  section right under their skills — before services and reviews — so it's
  one of the first things a client sees when deciding whether to trust
  someone with a project. Each entry is a clickable card linking straight
  to the work.
- No new database migration — this reuses the `portfolio` column that
  already existed on the users table; it just wasn't wired into any UI
  before now.

## Notes
- The minimum-2 rule is enforced when saving the portfolio (client-side and
  it's just filtered/validated in the save function) — it's not (yet) a
  hard gate on applying/claiming jobs the way ID verification is. If you
  want an empty/under-2 portfolio to also block applying to jobs, say so
  and I'll wire that in the same way as the ID-verification gate.
- Portfolio links are just URLs the provider pastes in — there's no file
  upload or embed preview (no audio/video player), so a Drive/YouTube/
  SoundCloud link just opens in a new tab when a client clicks it.

## Deploy steps
Just push — no migration to run.

## Post-release stability fixes
- Paystack callbacks now use the actual domain that initiated checkout instead of forcing `APP_URL`, preventing users from being sent to the Render hostname.
- Payment return verification no longer depends on an authenticated browser session; successful payments can be confirmed even if the customer's browser loses its session during the redirect.
- Payment records/jobs are updated on return verification as well as by the Paystack webhook path.
- Client-facing open-project view now shows platform activity summaries rather than other clients' project details.
- Identity verification submissions now remain `PENDING` until an admin approves/rejects them; uploaded ID/selfie bytes are stored in PostgreSQL so Render restarts do not erase them.
- Admin verification document/selfie viewing was hardened against popup blocking and missing ephemeral files.
- Reviewer application decisions now notify applicants and are audited.
- Dashboard route state is preserved across refreshes when the authenticated session is still valid.
- Added CI/environment template and updated production checks.
