# v5.63.2 — cancellation, dispute, reviewer, refund, mobile chat

- Fix PostgreSQL deadline arithmetic in cancellation and dispute inserts (carried forward from v5.63.1).
- Allow Tawk widget resources in Content Security Policy and keep a built-in support chat fallback.
- Keep the mobile navigation above chat overlays; keep the launcher above the tabs and open it on touch.
- Allow ADMIN_REVIEW dispute status via migration 034 and expose Admin final decision controls.
- Let qualified reviewers claim actual disputes and mandatory-review cancellations immediately; keep ordinary cancellations open for party settlement first.
- Distinguish partial from full Paystack refund webhooks using the refunded amount. A partial refund no longer cancels a released job.
- Close full wallet-refunded dispute jobs, and mark full Paystack refunds pending until confirmed.

Migration 034 runs automatically on startup. Check the Render deploy log for `Migration applied: 034_dispute_admin_review_status.sql`. Test cancellation, dispute, reviewer claim/escalation, Admin finalize, mobile tabs, and Tawk on a staging or low-value test project before using the payment decisions for real jobs.
