# v5.10.0 — Selfie required alongside the ID document

## What changed
- Provider verification now requires **two** uploads: the ID document (PDF/
  JPG/PNG) and a selfie photo (JPG/PNG, camera capture hinted on mobile).
  Both are required — the form won't submit without either.
- Admin's "ID Verification" tab now has separate **View document** and
  **View selfie** buttons so you can eyeball whether the face in the selfie
  plausibly matches the photo on the ID.
- New migration: `migrations/009_verification_selfie.sql`.

## What this is (and isn't)
This is a manual visual check — it doesn't automatically match faces or
verify liveness (e.g. detect a photo-of-a-photo). It does raise the bar
against casual fraud (someone submitting a stolen or found ID with no way
to connect it to their own face), and it becomes the thing you glance at
before approving/revoking someone in the ID Verification tab. Real
automatic face-matching and liveness detection is part of what the paid
providers (Dojah, Youverify, Smile ID, etc.) do — say the word whenever
you're ready to add that.

## Deploy steps
```
psql "$DATABASE_URL" -f migrations/009_verification_selfie.sql
```
(plus 006, 007, 008 if not already run), then push to GitHub and let Render
redeploy.
