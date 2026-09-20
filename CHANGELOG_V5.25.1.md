# PRODILIVE v5.25.1 — Paystack completion reliability fix

- Paystack webhooks are acknowledged only after PRODILIVE finishes processing them.
- Failed webhook processing releases the idempotency claim so Paystack retries are not silently discarded.
- Wallet deposits are credited server-side from signed `charge.success` events with amount/currency validation and an atomic status guard.
- Product purchases are now completed server-side by webhook instead of depending on the buyer returning to the browser callback.
- Payment callbacks infer deposit/product/job type from the PRODILIVE reference if custom callback query parameters are missing.
- Added focused Render logs for received, credited, confirmed, and unmatched Paystack events.
- Secondary webhook forwarding remains best-effort and cannot determine whether PRODILIVE credits its own payment.
