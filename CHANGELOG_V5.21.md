# v5.21.0 — Wallets (deposit/withdraw), job timing, deadline-miss refunds

## Job timing
- **Accepted timestamp**: recorded the moment a talent's claim or a client's
  assignment goes through — visible to both sides on the job page.
- **"Mark work as started" button** (talent-only): sets a separate started
  timestamp, distinct from "accepted" and from "funded."
- **Deadline is now visibly displayed** on the job page once accepted,
  turning red if it's passed and the job isn't finished.
- **"Deadline missed — cancel & refund me" button** (client-only): appears
  once the deadline has passed on an unfinished job. One click cancels it
  and refunds the client — via wallet credit if it was funded from wallet,
  or a real Paystack refund if funded by card.

## Wallets — deposit and withdraw, for both clients and providers
- Every account (client or provider) now has a **PRODILIVE wallet** with
  its own balance, shown on the dashboard.
- **Deposit**: enter an amount, pay via Paystack, it lands in your wallet
  (minus the admin-configurable deposit fee — defaults to 0%).
- **Fund a job straight from wallet balance** — a new "Pay from wallet
  balance" option sits next to the existing "Fund via Paystack" button, so
  a client with money already in their wallet can fund instantly with no
  redirect.
- **Provider earnings now land in the wallet instantly** the moment a
  client approves a delivery (or a dispute resolves in the provider's
  favor) — no more waiting on a bank transfer to complete.
- **Withdraw**: either role can withdraw their wallet balance to their own
  bank account (same payout-details form providers already used, now also
  available to clients) — minus the admin-configurable withdrawal fee
  (defaults to 2%). There is no way to deposit *without* going through
  Paystack first, and no way to move money between users directly — only
  in (via Paystack) and out (to your own verified bank account).
- Both fees are set in admin **Settings** (new "Wallet deposit fee" and
  "Wallet withdrawal fee" fields) — I also noticed and fixed a gap from
  last round where the reviewer case-fee setting existed on the backend
  but had no field in the Settings UI; that's fixed too.

## Under the hood
- New `wallet_ledger` table records every deposit, withdrawal, job
  earning, and refund — a full audit trail per user.
- The old payout-release flow (which did an immediate Paystack bank
  transfer the moment a job was approved) has been replaced by the wallet
  credit above — simpler, faster, and no longer blocked on a provider
  having entered bank details before their money can move.

## One inconsistency, said plainly
Reviewers already had their own separate earnings/withdrawal system built
last round (`reviewer_ledger`, its own balance/withdraw endpoints). This
round's wallet system for clients/providers is a **separate, parallel**
system (`wallet_ledger`) rather than a unification of the two — they work
independently and both function correctly, but a reviewer's "case fee"
balance and a provider's "job earnings" balance aren't the same ledger.
Say the word if you'd like these merged into one wallet system across all
roles — it's a reasonable follow-up, just not done automatically here to
avoid risking the reviewer flow that was already working.

## Deploy steps
Push and redeploy — `migrations/012_wallet_system.sql` auto-applies on
startup, no manual step needed.
