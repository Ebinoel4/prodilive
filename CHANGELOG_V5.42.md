# PRODILIVE v5.42 — Robase SMS Integration

- Replaced the legacy Sendar SMS adapter with the official Robase REST API.
- Uses `ROBASE_API_KEY` with Bearer authentication against `https://api.robase.dev`.
- Transactional alerts use `POST /v1/sms/send` and retain the v5.41 user-funded SMS wallet flow.
- SMS wallet records now store the Robase message ID, provider status, and returned credit cost when available.
- Phone verification now uses Robase OTP send/verify endpoints instead of generating the OTP inside PRODILIVE.
- Email and in-app notifications remain unchanged.
- No API secret is included in this package; configure `ROBASE_API_KEY` in Render.
