# PRODILIVE v5.17.0 — ZeptoMail transactional email

- Replaced the old SMTP/Nodemailer transport with the Zoho ZeptoMail Send API.
- Uses the ZeptoMail Send Mail Token from the configured Agent.
- Keeps `support@prodilive.com` as the branded sender.
- Preserves existing welcome, verification, password-reset, admin-alert, payment and notification email triggers.
- Added `ZEPTO_API_KEY` and optional `ZEPTO_API_URL` environment variables.
