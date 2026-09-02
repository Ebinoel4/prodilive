# PRODILIVE production launch checklist

## Required before real money
- [ ] Managed PostgreSQL with PITR and tested restore.
- [ ] Paystack live secret configured only in the secret manager.
- [ ] Paystack webhook configured to `/api/paystack/webhook`.
- [ ] HTTPS at the load balancer/reverse proxy.
- [ ] `APP_URL` and `CORS_ORIGINS` set to the real origin.
- [ ] SMTP configured and sender domain verified.
- [ ] Object storage/private bucket configured if replacing local persistent storage.
- [ ] Malware scanning/content inspection for uploaded files.
- [ ] Daily database backups plus offsite retention.
- [ ] Error monitoring, logs, uptime checks and alerting.
- [ ] Admin MFA/SSO at the infrastructure/identity layer.
- [ ] Terms, privacy, IP/licensing, refund and dispute policies reviewed for Nigeria.
- [ ] Paystack settlement/reconciliation process documented.
- [ ] Load test and independent penetration test completed.

## Payment safety
Never treat the browser redirect as payment proof. Only a verified Paystack response/webhook can move a payment to HELD. Never expose master files before RELEASED. Payouts are idempotent by job and are finalized by signed transfer webhooks.

## v5.0 hardening included
- [x] PostgreSQL persistence instead of JSON file storage.
- [x] Password hashing with bcrypt.
- [x] Hashed bearer sessions with expiry and logout.
- [x] Helmet, compression, CORS controls and API rate limiting.
- [x] Zod request validation on core job creation.
- [x] Signed Paystack webhook verification.
- [x] Paystack payment verification endpoint.
- [x] Idempotent webhook-event recording.
- [x] Payment amount/currency validation.
- [x] Protected master-file access until released payment.
- [x] Protected audio preview generation.
- [x] Refund endpoint and refund webhook handling.
- [x] Payout webhook handling and retry-safe payout records.
- [x] Audit logging, notifications, messages, reviews and disputes.
