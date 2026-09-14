# v5.7.0 — Real admin back end, provider ID verification, safety banner

## What changed

**Admin now lands on the real back end.** Logging in as admin (or clicking
"Dashboard") now redirects straight into the admin panel instead of the
generic client/talent dashboard — same fix pattern already used for
reviewers.

**Admin → Users tab**
- Shows each provider's ID-verification status
- New **Delete** button: soft-deletes the account (name/email scrubbed,
  logged out of every session, status set to `DELETED`) while keeping their
  job/payment/audit history intact for records and disputes. A true hard
  delete isn't offered because jobs, payments, and disputes reference the
  user row — deleting it outright would break that history.
- New **View activity** button: shows every project the user has been part
  of (with a direct link into that job's chat thread) and every support-chat
  conversation tied to their email, all on one screen.
- Passwords are intentionally **not** shown anywhere. They're stored as
  one-way bcrypt hashes — there is no way to display them, for anyone,
  including from the database directly. Suspend / reactivate / delete cover
  the actual admin need (stopping a bad actor) without that risk.

**Admin → new "ID Verification" tab**
- Lists every provider who has submitted a document, with Approve/Reject
  actions and a button to view the uploaded file.

**Provider identity verification**
- Talent/provider accounts now see an "Identity verification" section on
  their dashboard requiring a government ID / passport upload (PDF/JPG/PNG).
- New middleware blocks providers from applying to or claiming jobs until an
  admin approves their document. (Existing client and reviewer flows are
  unaffected.)
- Documents are stored privately on the server (`storage/verifications/`,
  not web-accessible) and only served back through the authenticated admin
  endpoint.

**Homepage safety banner**
- Added a short on-platform-only disclaimer under the existing "Protection"
  section: transacting off-platform voids protection and is at the user's
  own risk — plus a support email `mailto:` link.
- The support address lives in one place: the `SUPPORT_EMAIL` constant near
  the top of `public/index.html`'s `<script>` block. **Update this to your
  real Zoho support inbox before deploying** — it currently defaults to a
  placeholder.

## Deploy steps
1. Run the new migration: `migrations/006_admin_verification.sql` (also
   folded into `db/schema.sql` for fresh installs).
2. Edit `SUPPORT_EMAIL` in `public/index.html` to your real support address.
3. Push to GitHub, let Render redeploy.
4. No new env vars required for this round (reuses `DATABASE_URL` and the
   existing upload limits).

## Known infra note (not a code bug)
If sign-up, sign-in, or admin actions feel like they "hang" or load for a
long time — especially after a few minutes of no traffic — that's Render's
free-tier behavior: the service spins down when idle and takes 30–60+
seconds to wake back up on the next request. It isn't something this app's
code can fix from the inside; the options are an always-on Render plan or
moving off Render (e.g. to an always-on VM).
