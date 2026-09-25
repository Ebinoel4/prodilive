# Prodilive v5.58.1 — Render deployment

Use these Render settings:
- Runtime: Node
- Build Command: `npm ci --omit=dev`
- Start Command: `npm start`
- Node: 20 or newer (package.json enforces >=20)

Before deploying, apply migration `migrations/024_reviewer_invite_identity_terms.sql` to the production PostgreSQL database.

Required production environment variables remain the same as v5.57/v5.58. In particular, keep `MEDIA_SIGNING_SECRET` configured in Render. Do not commit `.env` or secrets.

This package deliberately excludes `node_modules`, local uploads, temporary files, and nested zip archives to keep the Render build artifact small and deterministic.
