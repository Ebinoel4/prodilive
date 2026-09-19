# v5.24.0 — Real fix for deposits not crediting, email self-diagnosis, light/dark theme

## The deposit bug — found the actual cause
Wallet deposits were **only ever confirmed by the browser redirecting back
to the site after payment**. If that redirect didn't complete for any
reason — the tab got closed, the connection dropped, the browser's back
button got used, anything — Paystack still had the money, but the site
never found out, and the balance stayed at 0 forever with no way to
recover it.

**Fixed**: your Paystack webhook (which already existed for job payments)
now also recognizes wallet deposits and credits them **server-side**,
independent of whatever happens in the browser. This is the reliable path
— it doesn't depend on the person staying on the page.

**One thing to check on your end**: this only works if Paystack is
actually configured to send webhook events to your site. In your Paystack
Dashboard → Settings → API Keys & Webhooks, confirm the **Webhook URL** is
set to:
```
https://www.prodilive.com/api/paystack/webhook
```
(your real domain, not the Render one). If that field is empty, Paystack
never told your site about *any* payment event, which would explain
deposits — and possibly other payment confirmations — not going through
reliably.

## Email — a real way to see what's actually wrong
Instead of guessing again, I added two things so you can see the exact
failure yourself:

1. **Startup check**: every time the server boots, it now tests the SMTP
   connection immediately and logs one clear line to Render's Logs tab:
   - `✓ SMTP connection OK — mail will send from ...`, or
   - `✗ SMTP connection FAILED at startup — emails will NOT send: <reason>`
   - or a warning if `SMTP_HOST` isn't set at all

2. **Admin → Settings → "Email diagnostics"**: a **Send test email**
   button. Click it and it either confirms delivery or shows you the
   *exact* error message right there in the page — wrong password, wrong
   port, connection refused, whatever it actually is — instead of a vague
   "email doesn't send."

Please deploy this and use that button first — whatever it shows you,
send me the exact text and I can tell you precisely what to fix (most
commonly: wrong `SMTP_SECURE` for the port you're using, or a regular
password used where Zoho requires an app-specific one).

## Light / dark theme
Added a toggle (🌙/☀️ button, top right of the nav) that switches between
the existing dark theme and a new light one, remembers your choice per
device, and applies instantly with no page flash.

## Deploy steps
Push and redeploy — no new migration. After it's live:
1. Check Render's Logs tab for the SMTP startup line
2. Try the "Send test email" button in admin Settings
3. Confirm your Paystack webhook URL is set correctly (see above)
4. Try a real test deposit again
