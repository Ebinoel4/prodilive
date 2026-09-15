# PRODILIVE v5.17.1

## Email + CORS hotfix
- ZeptoMail response bodies are now read once, so Render logs show the actual 4xx/5xx error returned by ZeptoMail.
- Password reset now waits for ZeptoMail and returns a clear failure instead of silently reporting success when delivery fails.
- Email sends log a safe success/failure message without exposing the API token.
- Added admin-only `/api/admin/email-status` diagnostics; no secrets are returned.
- Hardened CORS origin parsing and blocks malformed origins/control characters to prevent `ERR_INVALID_CHAR` response-header crashes.
- Startup logs now show whether transactional email is configured and which sender is being used.
