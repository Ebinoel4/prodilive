# PRODILIVE v5.40

- Marketplace is now a dedicated two-sided workspace with Shop, Sell, My Listings and Purchases tabs.
- Members can create marketplace listings from the Sell tab and manage their own listings separately from Profile.
- Purchases are accessible directly inside Marketplace.
- Admin accounts are blocked from the normal marketplace buying/selling workspace and are directed to Admin marketplace management.
- Replaced the Twilio-specific SMS adapter with a Sendar REST adapter suitable for sandbox/test-credit development.
- SMS remains opt-in. Production carrier delivery depends on provider credits/approval; in-app and email notifications continue independently.

Environment variables for SMS:
- SENDAR_API_KEY
- SENDAR_SENDER_ID (optional, defaults to PRODILIVE)
- SENDAR_BASE_URL (optional, defaults to https://api.sendar.io)
