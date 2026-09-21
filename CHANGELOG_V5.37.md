# PRODILIVE v5.37
- Reviewer/Admin job-chat messages now carry explicit PRODILIVE REVIEWER / PRODILIVE ADMIN identity labels.
- Assigned reviewers can read and send messages inside their dispute jobs; admins can do the same.
- Fixed dispute resolution buttons accepting either dispute ID or job ID.
- Fixed dispute refunds for wallet-funded jobs: refunds now return funds to the client's wallet instead of incorrectly calling Paystack.
- Paystack-funded dispute refunds still use Paystack's refund API.
- Release-to-talent continues to credit the talent's PRODILIVE wallet, with idempotent ledger protection.
- Admin is blocked at the API level from creating marketplace products; job creation already excludes admin.
- Admin footer Post Project action routes back to Admin instead of opening job creation.
