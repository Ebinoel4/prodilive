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
