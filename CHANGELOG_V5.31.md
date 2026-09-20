# PRODILIVE v5.31
- Replaced Paystack third-party wallet withdrawals with internal manual withdrawal requests.
- Requested amount is reserved immediately via PROCESSING wallet ledger entry.
- Added Admin > Withdrawals queue with Mark paid and Reject actions.
- Mark paid finalizes the ledger debit; reject returns the reserved amount to available balance.
- Stores payout snapshot and admin payment reference for auditability.
- Keeps Paystack for collections/deposits; no Paystack Transfers call is made for wallet withdrawals.
