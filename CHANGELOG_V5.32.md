# PRODILIVE v5.32

- Admin is now a backend-only workspace: public Find Talent / Find Work / Marketplace navigation is hidden for admin accounts.
- Added Admin > Beats & Templates with permanent delete controls.
- Admin product deletion hard-deletes the database listing/order links and removes master, preview and thumbnail objects from R2/S3 storage.
- Admin project deletion now hard-deletes closed/unfunded projects instead of leaving a DELETED row.
- Admin user deletion now permanently removes the account and dependent non-active records. Accounts with active/funded projects must be resolved first to protect money in flight.
- Payout details moved from dashboards into Wallet.
- Identity verification moved into Profile.
- Main user dashboard now lists active projects only; cancelled/completed work remains accessible through project/history flows.
- Added client Cancel Project for unfunded OPEN/AWAITING_PAYMENT jobs and talent Reject Job for unpaid assigned jobs.
- Reviewer mobile navigation is focused on Cases, Wallet and Profile; reviewer payout details live in Wallet.
- Marketplace audio previews use a bundled spoken “prodilive dot com” watermark loop every 10 seconds, so Render does not need a text-to-speech package at runtime.
