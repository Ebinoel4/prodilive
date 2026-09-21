# Prodilive v5.43

- Fixed unified Member delivery submission permissions.
- `/api/jobs/:id/deliver` now accepts `member`, `talent`, and legacy `client` roles.
- Delivery ownership is still enforced by `talent_id = authenticated user`, so only the professional assigned to that job can submit files.
- Reviewer is no longer granted the normal talent delivery route.
