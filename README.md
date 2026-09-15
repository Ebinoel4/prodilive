# PRODILIVE 3.0 — Production Marketplace

PRODILIVE is a trust-first marketplace for music, creative production and digital deliverables. The platform supports clients, talents, reviewers and administrators through a controlled lifecycle: brief → proposal/assignment → funding → production → protected delivery → technical QA → client review → approval/revision/dispute → payout.

## Included
- PostgreSQL persistence and indexed marketplace data
- bcrypt passwords and 30-day hashed bearer sessions
- Password reset and email verification flows (SMTP optional; development reset token is returned only outside production)
- Role-based access control for client, talent, reviewer and admin
- Job marketplace, proposals and talent assignment
- Paystack funding initialization, verification and signed webhooks
- Idempotent payment state transitions and payout records
- Protected masters and generated audio previews with FFmpeg
- Technical QA, revisions, client approval, automatic approval sweep and disputes
- Reviewer applications, qualification and dispute assignment/decisions
- In-app notifications and job-scoped messaging
- Payout profiles and Paystack transfer webhooks
- Admin overview, user controls, settings, jobs, payments, reviewer applications and audit log APIs
- Helmet, compression, API/auth rate limits, Zod validation, upload limits and graceful shutdown
- Responsive browser application for the main user workflows
- Docker Compose with PostgreSQL and persistent storage

## Local
1. Create PostgreSQL and set `DATABASE_URL`.
2. Run `psql "$DATABASE_URL" -f db/schema.sql`.
3. Copy `.env.example` to `.env` and replace every placeholder/secret.
4. `npm install`.
5. `npm start`.
6. Open `http://localhost:3000`.

## Docker
Set a real `PAYSTACK_SECRET_KEY` and replace the demo database/admin credentials in `docker-compose.yml` before internet exposure.

`docker compose up --build`

For production, put the application behind HTTPS and supply secrets through your deployment secret manager rather than committing `.env`.

## Included in 3.0
- Strict CORS configuration, request IDs and disabled Express fingerprinting
- Upload MIME allow-list and hardened Docker runtime
- Payment amount/currency verification before funding state changes
- Idempotent payout records created before provider transfer requests
- Nginx reverse-proxy configuration, CI workflow and backup/cleanup scripts
- Versioned migration entry point and production architecture/checklist docs

## Production hardening
The application is deployable as a production MVP, but no software can honestly be guaranteed “100% perfect” without running it in the target environment and completing an independent security review. Before processing significant real-money volume, use:
- managed PostgreSQL with PITR, tested backups and restricted network access;
- private S3-compatible object storage with signed URLs instead of local container storage;
- HTTPS behind a reverse proxy/load balancer and strict CORS allow-list;
- malware scanning for uploaded files and MIME/content sniffing;
- centralized logs, metrics, tracing and error alerts;
- CI with integration tests against PostgreSQL and Paystack test mode;
- admin MFA/SSO and secret rotation;
- real transactional email/SMS provider and verified sender domain;
- Paystack webhook endpoint configured in the dashboard and reconciliation monitoring;
- legal review for Nigerian consumer, tax, copyright/IP, privacy and marketplace obligations;
- load testing and an external application/security penetration test.

## Important payment rule
A successful transfer API response is not treated as final payout completion. The job remains `RELEASE_PENDING` until a signed Paystack transfer webhook confirms success. Failed/reversed transfers return the job to a payable state.

## Production requirements
Before accepting real money, configure the required production environment variables, HTTPS, managed PostgreSQL with backups/PITR, verified SMTP, Paystack webhook, private file storage strategy, malware scanning, monitoring and legal policies. The application refuses to start in NODE_ENV=production when core secrets are missing.
