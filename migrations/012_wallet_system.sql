CREATE TABLE IF NOT EXISTS wallet_ledger (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id),
  type text NOT NULL, -- DEPOSIT, WITHDRAWAL, JOB_EARNING, REFUND, JOB_FUNDING
  amount numeric(14,2) NOT NULL, -- positive = credit to wallet, negative = debit
  reference text,
  status text NOT NULL DEFAULT 'COMPLETED', -- COMPLETED, PROCESSING, FAILED
  meta jsonb NOT NULL DEFAULT '{}',
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS wallet_ledger_user_idx ON wallet_ledger(user_id, status);

ALTER TABLE jobs ADD COLUMN IF NOT EXISTS accepted_at timestamptz;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS started_at timestamptz;

INSERT INTO settings(key,value) VALUES('depositFeePercent','0') ON CONFLICT DO NOTHING;
INSERT INTO settings(key,value) VALUES('withdrawalFeePercent','2') ON CONFLICT DO NOTHING;
