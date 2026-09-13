# v5.6.0 — Forgot password + admin access fix

## What was actually broken
The admin API/dashboard code and the forgot/reset-password API endpoints were
already fully built in the backend (from earlier versions). Two separate gaps
made them invisible on the live site:

1. **Admin dashboard looked like a normal account.** The frontend only shows
   the "Admin" nav link and unlocks the admin dashboard when the logged-in
   user's `role` column is literally `admin` in the database. If the account
   you're using to log in was never promoted to `admin` (e.g. it doesn't match
   `ADMIN_EMAIL` on the server, or was registered before that env var was
   set), you just see the regular client/talent dashboard — nothing was
   actually missing from the code, the account itself just isn't an admin.

2. **No "Forgot password" link, and the reset link would 404.** The backend
   already had `/api/auth/forgot-password` and `/api/auth/reset-password`
   working. But (a) the login form never linked to them, and (b) the email
   sends people to `APP_URL/reset-password?token=...`, a plain page route —
   and the server had no fallback route to serve the single-page app for any
   URL other than `/`, so that link 404'd.

## What changed in this version
- **`src/server.js`**: added a catch-all `GET` route (excluding `/api/*`) that
  serves `public/index.html`, so `/reset-password?token=...` (and any other
  deep link) loads the app instead of 404ing.
- **`public/index.html`**: added a "Forgot password?" link on the sign-in
  form, a "Reset your password" request modal, and a "Choose a new password"
  modal that activates automatically when someone lands on
  `/reset-password?token=...` from the emailed link.
- **`scripts/promote-admin.js`** (new): run `node scripts/promote-admin.js
  you@yourdomain.com` on the server to flip an *existing* registered account
  to `admin` directly in the database — no env var juggling required.

## What you need to do after deploying this
1. **Get real admin access** — pick ONE:
   - Set `ADMIN_EMAIL` / `ADMIN_PASSWORD` env vars on your host to the
     account you want as admin, then restart the app (it auto-promotes/
     creates that account on every boot), **or**
   - Register/already have an account, then run
     `node scripts/promote-admin.js you@yourdomain.com` once on the server.
   - Log out and back in afterward — the nav "Admin" link and full dashboard
     (users, jobs, payments, disputes, settings, support) will appear.
2. **Set Zoho SMTP env vars** so verification + reset emails actually send:
   - `SMTP_HOST=smtp.zoho.com`
   - `SMTP_PORT=465`
   - `SMTP_SECURE=true`
   - `SMTP_USER=you@yourdomain.com`
   - `SMTP_PASS=<Zoho app-specific password>` (generate under Zoho Mail →
     Settings → Security → App Passwords if 2FA is on)
   - `MAIL_FROM=you@yourdomain.com`
   - `APP_URL=https://yourdomain.com` (used to build the links inside the
     emails — must be your real public URL)
3. Run any pending migrations as usual, then restart the app.
