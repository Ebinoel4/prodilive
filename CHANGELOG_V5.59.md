# PRODILIVE v5.59

- Fixed Talent search backend parameter bug that caused Internal Server Error.
- Added a proper Find Talent explanation for signed-out visitors.
- Added dedicated How It Works page with full project workflow.
- Added dedicated Payment Protection page.
- Added Suggestions button/modal, persistent suggestions storage, Admin suggestions view, and Admin email alert.
- Added Admin email alert for each withdrawal request.
- Preserved Admin email alert for identity-verification submissions.
- Added explicit verified payout-account state and enforced it server-side before withdrawals.
- Withdrawal requests are persisted in withdrawal_requests and wallet ledger; requested funds are reserved while pending.
- Added user-visible Withdrawal Requests history in Wallet.
- Removed identity-verification gating from normal job applications/instant claims; ID remains required for deposits, withdrawals, and Reviewer activation.
- Added migration 025_suggestions_payout_verification.sql.
