# PRODILIVE v5.0 Production Launch Runbook

## 1. Deploy the application

Recommended minimum production stack:
- Node.js 20+ or Docker
- Managed PostgreSQL 16+ with automated backups/PITR
- HTTPS reverse proxy/load balancer
- Persistent private object/file storage
- SMTP provider
- Paystack live integration

For a single-server launch, Docker Compose is included. For multi-instance scaling, move `storage/` to S3-compatible private object storage and serve files with authenticated/signed URLs.

## 2. Configure secrets

Copy `.env.example` to `.env` and replace every placeholder.

Required in production:
- `DATABASE_URL`
- `ADMIN_EMAIL`
- `ADMIN_PASSWORD`
- `PAYSTACK_SECRET_KEY` (your live `sk_live_...` key)
- `APP_URL`
- `CORS_ORIGINS`

Do not put the Paystack secret in frontend code or commit it to Git. Paystack documents live keys separately from test keys and requires secret keys to remain server-side. https://paystack.com/docs/api/authentication/

## 3. Database

Fresh database:
```bash
psql "$DATABASE_URL" -f db/schema.sql
```

Existing v4.1 database:
```bash
psql "$DATABASE_URL" -f migrations/002_production_hardening.sql
```

Existing v5.0 database, upgrading to the marketplace-v2 frontend (specialties, services, milestones):
```bash
psql "$DATABASE_URL" -f migrations/003_marketplace_v2.sql
```
This migration only adds a new `services` table and a `milestones` column on `jobs`
with a safe default — it does not modify or drop anything existing, and does not
touch payment logic. It's safe to run on a live database.

## 4. Paystack webhook

Set the webhook URL in the Paystack dashboard to:

`https://YOUR_DOMAIN/api/paystack/webhook`

The endpoint verifies the `x-paystack-signature` HMAC SHA512 signature, acknowledges quickly, and deduplicates repeated events. Paystack recommends webhooks for server-side confirmation and retries failed webhook deliveries. https://paystack.com/docs/payments/webhooks/

## 5. Payment flow

1. Client creates a job.
2. Client assigns a talent.
3. Job enters `AWAITING_PAYMENT`.
4. Client initializes Paystack payment.
5. PRODILIVE verifies the transaction and/or accepts the signed `charge.success` webhook.
6. Payment becomes `HELD` and the job becomes `IN_PROGRESS`.
7. Talent submits files.
8. QA moves the delivery to `CLIENT_REVIEW` or requests revision.
9. Client approves, or the configured auto-approval window expires.
10. Admin releases payout.
11. Paystack `transfer.success` moves the job to `RELEASED`.
12. Only then is the master file downloadable.

The browser callback is never treated as proof of payment; Paystack's Verify Transaction endpoint is used for authoritative confirmation. https://paystack.com/docs/payments/verify-payments/

## 6. Payouts

The admin payout action creates/uses a Paystack transfer recipient and sends the talent's net amount after the configured PRODILIVE commission. Payout records are idempotent per job and failed/reversed payouts can be retried safely.

Paystack sends `transfer.success`, `transfer.failed`, and `transfer.reversed` webhook events; PRODILIVE listens for these events before marking the job as released. https://paystack.com/docs/transfers/single-transfers/

## 7. Pre-live verification

Run:
```bash
npm install
npm run check
npm test
```

Then test in Paystack test mode:
- register/login/logout
- email verification and password reset
- create job
- talent proposal
- client accepts proposal
- initialize payment
- verify payment
- signed webhook
- delivery upload
- protected preview
- technical QA
- revision
- client approval
- auto approval
- dispute and split decision
- payout recipient creation
- transfer webhook
- master download lock/release
- refund flow
- notifications and messages
- admin user/settings/audit screens

Only after the full test flow passes should the live secret be enabled.

## 8. Real-money launch gate

Do not launch until these are complete:
- HTTPS enabled
- managed database + tested restore
- offsite backups
- private file storage
- malware/file inspection process
- error monitoring and uptime alerts
- admin MFA/SSO
- legal terms/privacy/IP/refund/dispute policies reviewed for Nigeria
- Paystack settlement reconciliation process documented
- independent security review/penetration test
- production Paystack webhook tested with a real low-value transaction

## 9. Operational checks

Health endpoint:
`GET /api/health`

It reports database availability, Paystack configuration presence, and the running application version.

Never expose `/api/health` secrets; it intentionally reports only whether Paystack is configured, not the key itself.
