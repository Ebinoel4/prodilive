# v5.25.0 — Share one Paystack account between two sites

## How it works
Paystack only allows one webhook URL per account, so Prodilive now acts as
the single receiver and **automatically forwards a copy of every Paystack
event to your other site**, with the original signature intact — so that
site's own webhook handler processes it exactly as if Paystack had called
it directly.

## What you need to do

**1. In Paystack's dashboard** (Settings → API Keys & Webhooks), set the
one Webhook URL field to Prodilive's:
```
https://www.prodilive.com/api/paystack/webhook
```

**2. On Render → your Prodilive service → Environment**, add:
```
SECONDARY_WEBHOOK_URL=<your other site's own webhook endpoint URL>
```
This is whatever URL that other site already expects Paystack to call —
check that site's own setup/docs for its exact webhook path (something
like `https://othersite.com/api/webhook/paystack` — I don't have visibility
into that codebase, so you'll need to find the exact path there).

**3. Push and redeploy.**

## What happens after that
- Every event Paystack sends (payments, refunds, transfers) arrives at
  Prodilive first
- Prodilive processes anything relevant to itself (job payments, wallet
  deposits, refunds, payouts) — unrelated events are simply ignored, same
  as before
- Right after acknowledging Paystack, Prodilive forwards the exact same
  raw event + signature to `SECONDARY_WEBHOOK_URL`, so your other site's
  own webhook handler verifies and processes it independently

## One honest limitation
This is fire-and-forget forwarding, not a guaranteed-delivery queue. If
your other site happens to be down at the exact moment an event arrives,
that specific forward is lost (it'll show up in Render's logs as "Webhook
forward to secondary site failed"), and Paystack won't be asked to retry
it since Prodilive already told Paystack "got it." In practice this is
rare, but it's worth knowing — if reliability across both sites matters a
lot, a proper message queue would close that gap, but that's a bigger
build than what's needed here.

## Deploy steps
Push and redeploy — no migration, just the two setup steps above (Paystack
dashboard + the new env var).
