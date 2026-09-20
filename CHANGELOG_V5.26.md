# PRODILIVE v5.26

- Added show/hide controls to password entry fields.
- Added wallet transaction history to client/talent dashboards.
- Added Funds on Hold totals for funded jobs awaiting release/resolution.
- Removed Nigeria-specific marketing positioning and changed public copy to global positioning.
- Added currency field migration to the wallet ledger as groundwork for processor-backed multi-currency.
- Kept Paystack NGN processing unchanged until each settlement currency is explicitly enabled by the payment provider/account; the UI must not pretend unsupported currencies can be charged.
- Preserved held-payment workflow: client funding remains held until approval/dispute resolution; talent earnings become wallet-available only on release.
- SMTP diagnostic behavior retained; actual Zoho timeout still requires valid reachable SMTP host/port/TLS credentials in deployment environment.
