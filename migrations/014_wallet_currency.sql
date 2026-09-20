ALTER TABLE wallet_ledger ADD COLUMN IF NOT EXISTS currency text NOT NULL DEFAULT 'NGN';
CREATE INDEX IF NOT EXISTS wallet_ledger_user_currency_idx ON wallet_ledger(user_id, currency, status);
