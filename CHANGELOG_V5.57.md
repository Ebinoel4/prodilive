# PRODILIVE v5.57 — Security Hardening

- Identity verification uploads now remain PENDING until admin review; users can no longer self-approve ID verification merely by uploading files.
- Wallet project funding now uses a dedicated PostgreSQL transaction, row/advisory locking, and an atomic balance check to reduce double-spend/race-condition risk.
- Production now requires an explicit MEDIA_SIGNING_SECRET and a stronger admin password.
- Protected-media tokens default to 15 minutes (configurable, capped at one hour) instead of four hours.
- Socket.IO CORS is restricted to configured application origins.
- Added stricter cross-origin/referrer/permissions/HSTS security headers while preserving the current inline frontend compatibility.
- Production health endpoint no longer discloses integration configuration details.
- Identity upload limit defaults to 15 MB; general creative upload default reduced to 150 MB per file to reduce memory-exhaustion exposure (configurable).
- Fixed wallet webhook error-path expected amount handling.
- Added CI workflow for syntax and test checks.

Important: Content-Security-Policy remains disabled because the current single-file frontend relies heavily on inline scripts/styles/onclick handlers. Moving the frontend to external JS/CSS should be a future hardening task so a strict CSP can be enabled safely.
