# v5.15.0 — Session logout bug, payment redirect, document storage, admin notifications

## 1. Fixed: refreshing the page logs you out
**Root cause:** on every page load, the app calls `/api/me` to restore your
session. The code treated *any* failure of that call — a network blip, a
slow Render cold-start, a temporary 500 — as "your token is invalid" and
wiped it from storage. So an ordinary hiccup on refresh looked exactly like
being logged out.

**Fix:** the app now only clears your session on an actual `401
Unauthorized` from the server. Every other kind of failure (timeouts,
network errors, temporary server issues) leaves your login alone — refresh
again and it picks up right where you left off.

## 2. Fixed: Paystack payment not redirecting back
**Root cause:** the payment-initialize calls never told Paystack where to
send you back to (`callback_url`), so Paystack fell back to whatever's in
your Paystack Dashboard settings — often nothing — which is why it just
sat there after payment instead of returning to the app.

**Fix:** every payment now explicitly tells Paystack to redirect to
`/payment-callback` on your site. Landing there automatically verifies the
payment, shows a confirmation toast, and takes you straight to the funded
project. This requires `APP_URL` to be set correctly to your real domain
(see the domain note below).

## 3. Fixed (with a caveat): admin "could not load document"
**Root cause:** Render's local disk is wiped on every redeploy unless you
pay for a persistent disk. Every uploaded verification document/selfie
from earlier rounds has been silently deleted each time this app got
redeployed — which has been often, during this build process. The database
still remembered the filename; the file itself was long gone.

**Fix:** added optional durable storage via Cloudflare R2 (S3-compatible,
free up to 10GB, no bandwidth charges). See `docs/FILE_STORAGE.md` for the
5-minute setup. Until you set that up, uploads keep working exactly as
before but remain temporary — any test document you upload before this
gets configured (or before the *next* redeploy) will need to be re-uploaded
once it's set up properly.

**This same risk still applies to job deliverable files** (originals/
previews) — not yet migrated to R2. Say the word and I'll extend it.

## 4. Fixed: reviewer applications had no Reject button
Admin's Reviewer Apps tab only offered "Approve → qualification test" for
pending applications — there was no way to reject one outright. Added a
Reject button next to it.

## 5. Admin now gets emailed automatically
Two new automatic emails to your `ADMIN_EMAIL` address:
- **New user signup** — name, email, role, whenever someone registers
- **New ID document submitted** — whenever a provider uploads a
  verification document, so you know to go check it (and revoke it if
  something looks off)

No setup needed beyond the SMTP env vars you already have — these ride on
the same mailer as everything else.

## 6. On your other email questions
These are already live (from earlier rounds) and should now actually work
reliably now that #1 and the non-blocking-email fix (v5.12.0) are in:
- **Welcome email** — sent automatically at registration
- **Forgot-password email** — sent automatically when requested
- **"Your request/proposal was approved" email** — already fires
  automatically when a client assigns a job to a provider or accepts their
  proposal (uses the same notification-email system as chat messages, job
  status changes, etc. from v5.8.0)

If any of these still don't arrive after this deploy, it's worth double-
checking your Zoho SMTP env vars are exactly right (host/port/secure/user/
pass/from) — that's the more likely remaining cause at this point.

## 7. On the domain still showing Render sometimes
This version doesn't change anything about hosting/DNS — that's a Render +
domain-registrar configuration step, not app code. Two things worth
checking on your end:
- In Render → your service → **Settings → Custom Domains**, make sure your
  domain is added and shows a green "Verified" status (not just "Pending").
  If it's still pending, your domain's DNS records (usually a CNAME or A
  record, whichever Render's dashboard tells you to add) haven't fully
  propagated yet — that can take anywhere from minutes to 24-48 hours.
- Make sure `APP_URL` in your environment variables is set to your actual
  custom domain (`https://yourdomain.com`), not the `onrender.com` one —
  this app uses that value to build email links, the Paystack callback, and
  CORS. If `APP_URL` is still the Render URL, browsing the app via your
  custom domain can cause exactly the kind of "buttons don't work" issue
  you're describing, since the API would reject requests coming from an
  origin it doesn't recognize.

## 8. Client page — need clarification before changing
I didn't touch this one yet since "just show a summary" could mean very
different things depending on which page — see my reply for the specific
question.

## Deploy steps
1. Push to GitHub, let Render redeploy (auto-migration, so no manual SQL
   step).
2. Optional but recommended: set up Cloudflare R2 per
   `docs/FILE_STORAGE.md` so verification uploads finally stick.
3. Double-check `APP_URL` is your real custom domain, not the Render one.
