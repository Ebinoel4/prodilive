# v5.20.0 — Reviewer signup relocated, jobs gated, live job removal, email guide

## Fixed per your last message
- **Removed the "Become a Reviewer" prompt from client/provider dashboards.**
  The only way to reach reviewer signup now is the **"Become a Reviewer"**
  link in the main site nav, which opens its own dedicated signup form —
  it's never suggested to someone already using a client/provider account.
- **Jobs browsing now requires being signed in.** Anonymous visitors can no
  longer see `/api/jobs` or the Find Jobs page — clicking it while logged
  out opens the sign-in prompt instead. (Find Talent and provider profiles
  are unaffected and still public — that's the "let clients vet a provider
  before signing up" feature from before.)
- **Claimed/assigned jobs now disappear from Find Jobs live**, for everyone
  currently looking at the list — no manual refresh needed. This covers
  both instant-claim jobs and jobs a client manually assigns from a
  proposal.
- **Removed "Joined [time ago]" from Find Talent cards.**

## Answering your other questions

**Is every button working?** As far as a systematic audit can tell — yes.
I cross-checked every `onclick`/`onchange`/`onsubmit` against its function
and every frontend API call against a real backend route in the v5.18.0
round; nothing was found calling something that doesn't exist. The two
real gaps found and fixed were missing UI for payout release/refund and
missing admin job/user actions — those are done now (v5.18–5.19). The one
known remaining gap, called out honestly: the **products/beats
marketplace** has a working backend but no seller-listing or "My
Purchases" UI yet — say the word if you want that built.

**How do I customize the welcome/forgot-password/verification emails?**
These are plain text strings inside `src/server.js` — there's no separate
template file (yet) — search for these exact spots:
- **Verification email**: search for `'Verify your PRODILIVE email'` —
  appears twice (regular signup and reviewer signup)
- **Welcome email**: search for `'Welcome to PRODILIVE'`
- **Forgot-password email**: search for `'Reset your PRODILIVE password'`
- **Activity notification emails** (job messages, approvals, disputes,
  etc.): search for `PRODILIVE — ${title}` inside the `notify()` function
  — this one wraps *every* notification type, so editing it changes the
  shared wrapper text around all of them, not one specific email

Each is a plain JavaScript template string (backtick-quoted) — edit the
wording directly, keep the `${...}` parts (those insert real names/links),
save, and redeploy. If you'd like these moved into one clearly-labeled
`EMAIL_TEMPLATES` section for easier editing, or turned into HTML-styled
emails instead of plain text, tell me and I'll do that as its own change.

**Do email links lead back to the site correctly?**
- **Forgot-password link** → `/reset-password?token=...` → opens the
  "choose a new password" form directly (fixed in v5.17.0)
- **Verification link** → previously just showed raw JSON in the browser;
  **now redirects to your homepage** with a friendly "Email verified —
  welcome to PRODILIVE!" toast (or a clear error toast if the link was
  expired/invalid)
- **Activity notification emails** (new message, approval, dispute, etc.)
  link to your homepage, not the specific job/dispute — a visitor still
  has to navigate from there. Deep-linking each one to its exact page is a
  reasonable next improvement if you want it.
- All of these depend on `APP_URL` being set correctly (no trailing
  slash) — confirmed fixed at the source since v5.17.0 regardless.

## Deploy steps
Just push — no new migration, no env var changes.
