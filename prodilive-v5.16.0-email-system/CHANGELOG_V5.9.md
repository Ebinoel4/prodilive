# v5.9.0 — ID type selector on the verification upload

No automatic government-database checking added (that needs a paid
third-party API — Dojah, Youverify, Smile ID, etc. — none of them are free
in production, only sandbox/testing is). Skipping that for now, per your
call.

## What changed
- The provider identity-upload form now includes a dropdown for the type of
  ID being submitted: National ID (NIN), International passport, Driver's
  license, Voter's card, or Other government ID.
- That selection is stored alongside the document (`verification_doc_type`)
  and shown to you in the admin "ID Verification" tab, so you can see at a
  glance what kind of document each provider submitted.
- New migration: `migrations/008_verification_doc_type.sql`.

## Deploy steps
```
psql "$DATABASE_URL" -f migrations/008_verification_doc_type.sql
```
(plus 006 and 007 from the last two rounds, if not already run), then push
to GitHub and let Render redeploy.

## If you want real automatic verification later
Whenever you're ready to pay for it, tell me which provider (Dojah is the
cheapest, pay-as-you-go, Nigeria-focused option) and I'll wire the API call
in — swap the current "store the file" step for "call their API with the ID
number, get back a match/no-match against the government record."
