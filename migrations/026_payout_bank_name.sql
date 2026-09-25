-- v5.60: keep a readable copy of the user's verified withdrawal bank name.
ALTER TABLE users ADD COLUMN IF NOT EXISTS payout_bank_name TEXT;
