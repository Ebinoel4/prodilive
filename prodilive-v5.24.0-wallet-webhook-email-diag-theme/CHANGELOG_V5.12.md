# v5.12.0 — Fixed the actual cause of "keeps loading forever"

## The real bug (not just Render cold starts)
Every email-sending request — register, forgot-password, resend-
verification, and every activity notification — was written to **wait for
the email to fully send before responding to the browser**:
```js
if (mailer) await sendMail(...);   // the whole HTTP request sat here
res.json({ ok: true });            // never reached until email finished
```
If Zoho's SMTP server was slow to respond, temporarily unreachable, or
Render's network took a while to complete the handshake, the entire
request — and therefore your "Send reset link" / "Create account" button's
spinner — would hang until that finished. That's almost certainly what you
were seeing on "Forgot password" (and likely explains some of the earlier
"account creation hangs" reports too, on top of Render's cold starts).

## The fix
- Every email send is now **fire-and-forget**: the server inserts the
  reset token / verification token into the database and responds to the
  browser immediately. The actual email goes out in the background a
  moment later. If it fails, that only shows up in Render's logs — it can
  no longer freeze the page.
- Added timeouts to the SMTP connection itself (10 seconds each for
  connecting, greeting, and socket activity), so even the background send
  fails fast and logs clearly instead of hanging indefinitely if Zoho is
  unreachable.

## What you should see now
- Clicking "Send reset link" (or registering, or resending a verification
  email) should resolve in well under a second — the button stops spinning
  right away.
- The actual email might arrive a second or two later than the page
  responds, which is normal and expected.
- If an email genuinely fails to send (bad credentials, Zoho blocking the
  connection, etc.), the page will still work fine — check Render's Logs
  tab for a line like `Email send failed: ...` to diagnose the SMTP side
  separately.

## Deploy steps
Just push and let Render redeploy — no new migration this round, no env
var changes needed.
