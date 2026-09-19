# v5.23.0 — Reviewer applications now work like a real job application

## The new flow
1. Someone clicks **"Become a Reviewer"** and fills out a form: name,
   email, experience, specialties, an ID document, and a selfie — **no
   password, no account created yet.**
2. You review it in admin **Reviewer Apps** — their name/email, a **View
   document** and **View selfie** button, and two actions: **Send
   registration invite** or **Reject**.
3. In the meantime, you can reply to them directly at the email address
   shown — nothing in-app is needed for that conversation, it's just your
   own inbox.
4. If you click **Send registration invite**, they get an email with a
   link. Clicking it lets them set a password — **that's the moment their
   actual login-capable account gets created**, pre-filled with the name/
   email they applied with.
5. From there, the existing qualification-test flow (score 0-100 →
   CERTIFIED/TRAINEE/REJECTED) still applies before they can claim
   disputes — unchanged from before.

If you reject an application, they get a polite email letting them know.

## Why this instead of instant sign-up
This matches what you described: applying should feel like applying for a
job, with you in the loop reviewing documents and corresponding by email
before anyone gets real access — not an account that exists the moment
someone fills out a form.

## What changed under the hood
- `reviewer_applications` can now exist with no linked user account yet
  (new `applicant_name`/`applicant_email`/document fields).
- New `reviewer_invites` table tracks the one-time, 7-day registration
  links.
- The old "Become a Reviewer" flow that created an account instantly is
  removed from the sign-up path (the endpoint still exists server-side,
  unused, in case you ever want it back — same pattern as the old
  promote-an-existing-account path from a few rounds back).

## Deploy steps
Push and redeploy — `migrations/013_reviewer_application_flow.sql`
auto-applies, nothing manual needed.

## Please test end-to-end once live
1. Submit a test application via "Become a Reviewer" (with a real
   document + selfie)
2. Check it shows up in admin Reviewer Apps with working document/selfie
   view buttons
3. Click "Send registration invite," confirm the email arrives
4. Click the link in that email, confirm it lets you set a password and
   creates the account
