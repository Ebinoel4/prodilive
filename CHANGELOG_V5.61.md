# v5.61.0 — Cancel vs Dispute split, anti-abuse, live chat

## 1. Cancel and Dispute are now genuinely separate flows
- **Cancel project** (client, no-fault reasons: changed mind / different creative
  direction / not satisfied / mutual agreement) — new professional modal with
  clickable reason cards (no more `prompt()` popup), a text box for details, and
  an optional voluntary top-up for the talent.
- **Open a dispute** (either party, fault-based: outside brief / missed deadline /
  non-delivery / other) — separate modal, always goes to a reviewer, funds frozen.
- Enforced server-side too: `/api/jobs/:id/cancel-request` only accepts the soft
  reasons, `/api/jobs/:id/dispute` only accepts the fault-based ones.

## 2. Anti-abuse for the Cancel button
- Cancelling no longer unilaterally executes the compensation split. It creates a
  **proposal**. The other party sees a banner on the project page and can:
  - **Accept** → settles instantly (money moves right away, no reviewer needed), or
  - **Escalate** → sends it straight to a reviewer for a real decision.
  - If neither happens, the existing settlement window still applies and a
    reviewer can pick it up once it expires.
- **Repeat-cancellation tracking**: if an account opens 3+ cancellations in a
  rolling 30 days (configurable via Admin → Settings → `softCancelMonthlyLimit`),
  further ones automatically skip the instant-settle option, get routed straight
  to reviewer review, and flag the account (visible in Admin → Users) — so
  nobody can repeatedly walk away paying talent only 20% by claiming "changed
  my mind" over and over.

## 3. Live chat
- Project chat now pushes new messages instantly over the existing Socket.IO
  connection (new `job:<id>` rooms) instead of waiting on a 6-second poll.
  A slow 25s poll remains only as a safety net if a socket connection drops.

## Deploy notes
- Run `migrations/030_cancel_vs_dispute_live_chat.sql` (auto-runs on startup,
  per the existing auto-migration system — no manual psql needed).
- No new env vars required.
- No breaking changes to existing disputes already in progress.

## Known follow-ups (not built, flagged for later if wanted)
- The reviewer-side dispute decision UI (Release/Refund/Split) still uses
  `prompt()`-style inputs in a couple of places — not touched in this round
  since it wasn't part of what was asked.
- Escalation currently still routes to the general reviewer pool rather than
  a different specialized escalation lane.
