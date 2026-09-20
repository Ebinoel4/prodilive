# PRODILIVE v5.30
- Resend HTTPS transactional email support via RESEND_API_KEY / RESEND_FROM (SMTP fallback retained).
- Forgot password, verification, welcome, notifications and admin test email use the unified email sender.
- Dynamic Paystack bank lists by payout market instead of a hard-coded Nigerian bank list.
- Payout profile now stores country, currency and recipient type for future multi-provider/global payout expansion.
- Automatic account-name resolution for Paystack markets that support it (Nigeria/Ghana).
- Wallet withdrawals return actionable provider errors instead of a generic internal-server error.
- Detects Paystack transfer OTP requirement and explains how to enable fully automatic withdrawals.
- Cloudflare R2/S3-compatible durable storage support from v5.29 retained.
