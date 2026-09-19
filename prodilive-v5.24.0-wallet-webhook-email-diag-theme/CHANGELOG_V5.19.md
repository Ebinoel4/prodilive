# v5.19.0 — Client-triggered payouts, dispute pool, anonymous reviewers, admin job actions

## Admin: full job control
- **Cancel** a job (auto-refunds the client if it was funded)
- **Delete** a job (soft — hidden everywhere, kept on record; blocked if funds are still in escrow)
- **Change any user's role** directly from the Users tab (was API-only before)

## Payouts no longer wait on admin
When a client clicks **Approve**, the payout to the provider now fires
automatically in the same action — no more waiting on an admin to hit a
separate button. If it can't go through immediately (provider hasn't added
payout details yet), the job stays correctly marked "payout pending," the
provider is told to add their details, and you get an email so you can step
in if needed. The admin manual release button is still there as a backup/
retry tool.

**Also fixed a real bug while I was in there:** the manual payout-release
endpoint was querying a database column (`commission`) that never existed —
it would have failed every single time it was actually invoked.

## Disputes: open pool + real-time alerts + anonymous reviewers
- Opening a dispute now instantly alerts every reviewer currently online
  (via your existing real-time connection) — no admin has to manually
  assign it.
- Reviewers see an **Available disputes** pool and can **claim** any case
  themselves, first-come-first-served.
- Reviewer identity was already never exposed to the client/provider in a
  dispute (only an internal ID, never a name) — tightened further so even
  that internal reference is hidden from anyone except the assigned
  reviewer and admin.
- Deciding a dispute now actually **acts** on the outcome: releasing to the
  provider, refunding the client, or splitting between the two — all
  happen automatically the moment a reviewer decides, instead of just
  recording a decision with no money movement.

## Reviewers: separate signup, earnings, withdrawals
- New **"Become a Reviewer"** button (nav bar) opens its own dedicated
  signup form — a completely separate account, not a promotion from an
  existing client/provider account. A reviewer account can never post,
  apply to, or claim jobs — that's enforced structurally by the same
  role-based permission checks every other action already uses.
- Reviewers earn a **percentage fee per resolved case**, set by you in
  admin Settings (defaults to 5%).
- New **Reviewer Hub**: available disputes to claim, assigned cases,
  case history, guidelines, earnings balance, and a **Withdraw** button
  that pays out to their own bank details (same payout-profile form
  providers use) — reviewers can withdraw but never deposit, since they
  never handle client payments directly.

## Known limitation, said plainly
The old path (an existing client/provider "applying" to become a reviewer
from inside their dashboard) still technically exists on the backend for
admin flexibility, but isn't the advertised flow anymore — the new
dedicated signup is what's linked from the site. If you want the old path
fully removed, say so and I'll take it out.

## Deploy steps
1. Run the pending migration: `migrations/011_reviewer_system.sql` — or
   just push and let it auto-apply (self-migration has been in place since
   v5.11.0).
2. In admin **Settings**, check the reviewer fee percentage is what you
   want (defaults to 5%).
3. Push and redeploy.
