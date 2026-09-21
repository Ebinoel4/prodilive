# PRODILIVE v5.39 — Job Alerts, SMS, Talent Withdrawal & P2P Chat

- Matching-job alerts: members whose saved skills match a new job category/deliverables receive an in-app alert and, when enabled, email; optional SMS is supported after phone verification.
- SMS preferences added to Profile for matching jobs, deadline reminders, and important project/payment events.
- Phone verification by 6-digit SMS code. SMS is disabled unless Twilio environment variables are configured.
- Delivery deadline reminders are generated at 48h, 24h, 6h and 1h windows and sent in-app/email; SMS follows the user's opt-in preference.
- Talent can withdraw from a project before a delivery has been submitted. Unfunded jobs reopen; funded jobs cancel and refund the client (wallet immediately, Paystack through refund processing).
- Project chat redesigned as a professional P2P chat with avatars/initials, left/right bubbles, role labels, timestamps, and a persistent on-platform safety notice.
- Existing reviewer/admin labels remain explicit in project chat.
- Adds migration 020_notifications_sms_chat_cancel.sql.
