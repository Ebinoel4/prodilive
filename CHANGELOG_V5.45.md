# PRODILIVE v5.45 — Integration Reliability + Marketplace Navigation

- Marketplace promoted to a first-class main navigation item on desktop and mobile.
- Job matching now scans title, description, category, deliverables and acceptance criteria, and supports unified member/legacy talent/client accounts.
- Matching notifications use one preference-aware path for in-app, Resend email and Robase SMS.
- Robase phone numbers are normalized to E.164, including Nigerian 080... numbers.
- Added user-initiated `/api/me/sms/test` to expose low-wallet, unverified-phone and provider failures instead of silently hiding them.
- Added admin integration diagnostics endpoint for Resend configuration, Cloudflare R2 reachability, Robase reachability and Paystack configuration.
- Production uploads now refuse to persist to ephemeral Render disk when R2 is not configured. Durable verification, job delivery, project attachment, marketplace master/preview/cover uploads use R2.
- Unified Member accounts can upload identity verification and create services.
- Explore includes unified members as providers.
