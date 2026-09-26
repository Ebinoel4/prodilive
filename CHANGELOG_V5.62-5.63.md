# v5.62.0 – v5.63.0 — Security hardening + cancellation bugfix + business rules

## 0. Fixed: "Internal server error" on Cancel/Dispute submission
Root cause: the migration runner executed each migration file as one giant
multi-statement batch. Postgres runs a multi-statement batch as one implicit
transaction — if any single statement in the file has a problem, **every**
statement in that file gets rolled back, including ones that already
succeeded. If migration 030 (which added the `kind`/`requires_reviewer`
columns the new Cancel/Dispute endpoints need) hit any issue at all on your
DB, none of its columns would exist — and every request to the new
endpoints would then fail with a generic Postgres "column does not exist"
error, surfaced to you as "Internal server error."

Fixed properly, not just patched around:
- The migration runner now executes each **statement** in a file
  independently (own transaction each), logs the exact failing statement +
  Postgres error to the console, and **emails you** (`notifyAdmin`) if one
  fails — so this class of bug is never silent again.
- Added `031_cancel_dispute_columns_safety_net.sql`, a redundant, fully
  idempotent re-run of the exact columns Cancel/Dispute needs, so this
  specific issue is fixed on redeploy regardless of what happened to 030
  before.
- **You must redeploy/restart the app for this fix to take effect** — the
  broken state persists until the process restarts and the migration runner
  gets a chance to retry.

## 1. Security hardening
- **Content-Security-Policy is now on** (was explicitly disabled before).
  Blocks plugin/object embeds, `<base>`-tag hijacking, the site being framed
  by another domain (clickjacking), and — the most important one — limits
  which hosts any injected script could ever send stolen data to
  (`connect-src 'self'`). Honest caveat: the frontend's architecture (inline
  `onclick=` handlers everywhere, inline `style=` attributes) still requires
  `'unsafe-inline'` for script-src/style-src — closing that gap fully would
  mean rewriting every event handler to `addEventListener`/data-attributes,
  a much bigger job than turning CSP on. Flagging this so it's a known,
  intentional trade-off rather than a silent one — happy to take that on as
  a dedicated follow-up if you want the stronger version.
- **Per-account login lockout**, on top of the existing per-IP rate limit
  (which alone doesn't stop a brute force spread across many IPs against one
  specific account). After a configurable number of failed attempts (default
  8), the account locks for a configurable duration (default 15 minutes),
  independent of source IP. Resets on a successful login. You get an email
  when an account gets locked. Both numbers are editable in Admin → Settings.

## 2. Cancellation business rules
- **Mandatory minimum compensation for started work**: if a talent has
  clicked "Mark work as started" and it's been more than a configurable
  number of hours (default 48h), cancelling always guarantees the talent at
  least a configurable minimum (default 20%) — regardless of which no-fault
  reason is picked, even "mutual" (which otherwise defaults to 0%). Both
  numbers are editable in Admin → Settings.
- **Repeat-cancellation warning shown up front**: the Cancel modal now
  tells the client, before they submit, that repeatedly cancelling projects
  can flag their account for review (the actual flagging/reviewer-routing
  logic was already built in v5.61.0 — this just surfaces the warning in
  the UI instead of only finding out after the fact).
- **Auto-settle after the response window, without consent**: previously,
  if the talent never responded to a cancellation proposal, it just sat
  frozen indefinitely (a reviewer *could* claim it once the window passed,
  but nothing forced that to happen). Now a background sweep (every 5 min,
  same pattern as the existing overdue-job checker) automatically applies
  the proposed split once the settlement window passes with no response —
  it goes through without needing the talent's consent, exactly as
  requested. Both parties get notified when this happens. This only applies
  to the self-service "instant-settle-eligible" cancellations — ones already
  routed to a reviewer (repeat offenders, or disputes) are unaffected and
  still wait for an actual reviewer decision.

## Deploy notes
- Migrations `031`, `032`, `033` all auto-run on startup as usual.
- **Redeploy/restart is required** — this is what actually fixes the
  Internal Server Error, not just having the code.
- No new env vars required.
- New Admin → Settings fields: repeat-cancellation limit, mandatory
  compensation hours/%, login lockout threshold/duration.
