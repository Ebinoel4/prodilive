# v5.8.0 — Email-on-activity, auto-approve verification, extended sign-up

## What changed

**Every notification now also emails the user** (only when SMTP env vars are
set — see below). This is one change to the shared `notify()` function used
throughout the app, so it covers: new job messages, job claimed/delivered/
approved/disputed, support chat replies, and verification decisions — not
just chat. If you want to dial specific ones back later, they can be split
out individually.

**Welcome email added.** Registration now sends two emails: the existing
verify-your-email link, and a separate welcome message.

**Provider ID verification is now auto-approved on upload** — no manual
review queue. Uploading a document immediately sets status to `APPROVED`
and unlocks apply/claim. The admin "ID Verification" tab still lists every
submission and lets you view the document and **Revoke** anyone who looks
suspicious later (which immediately re-blocks apply/claim), or **Approve**
someone you'd previously revoked. This trades strict pre-screening for
"documented, not bottlenecked" — tell me if you'd rather flip it back to
manual review once you have more admin bandwidth.

**Extended registration form.** Sign-up now also asks for: nickname
(display name), phone number, country, state, city, and address — all
required. These are stored on the user record and visible to you in the
admin Users → View activity screen and via `/api/me`. Applies to new
sign-ups only; existing accounts will have these fields empty until they
update their profile (a "complete your profile" prompt for existing users
isn't built yet — say the word if you want that added).

## Deploy steps
1. Run the two new migrations, in order:
   ```
   psql "$DATABASE_URL" -f migrations/006_admin_verification.sql
   psql "$DATABASE_URL" -f migrations/007_registration_fields.sql
   ```
   (Skip 006 if you already ran it last round.)
2. Push to GitHub, let Render redeploy.

## About the emails specifically

**Automatic verification + welcome + forgot-password emails all use the same
SMTP setup** — there's nothing extra to configure beyond the Zoho env vars
from before:
```
SMTP_HOST=smtp.zoho.com
SMTP_PORT=465
SMTP_SECURE=true
SMTP_USER=you@yourdomain.com
SMTP_PASS=<Zoho app-specific password>
MAIL_FROM=you@yourdomain.com
APP_URL=https://yourdomain.com
```
Once those are set on Render and the service restarts, every email in the
app (verify, welcome, forgot-password, and now activity notifications) sends
automatically — there's no separate switch to flip per email type.

## On "unverified users can still do everything"
Two different verification flags exist and they gate different things,
narrowly on purpose:
- **Email verification** (`emailVerified`) blocks posting jobs, applying to
  jobs, and payments — but intentionally not browsing, messaging, or editing
  a profile.
- **ID verification** (`verificationStatus`, providers only) blocks applying
  to and claiming jobs — added in the previous round (v5.7.0).

If you tested this before pushing v5.7.0/v5.8.0, that's why it looked like
it had no effect — the gating code didn't exist on the live site yet. Once
this version is deployed, try applying/claiming as an unverified provider
account and it should now be blocked with a clear error message.
