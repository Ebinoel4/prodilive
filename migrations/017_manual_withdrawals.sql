CREATE TABLE IF NOT EXISTS withdrawal_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id),
  reference text UNIQUE NOT NULL,
  amount numeric(14,2) NOT NULL,
  fee numeric(14,2) NOT NULL DEFAULT 0,
  payout_amount numeric(14,2) NOT NULL,
  currency text NOT NULL DEFAULT 'NGN',
  country text,
  bank_code text,
  bank_name text,
  account_number text,
  account_name text,
  status text NOT NULL DEFAULT 'PROCESSING',
  admin_reference text,
  admin_note text,
  processed_by uuid REFERENCES users(id),
  processed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS withdrawal_requests_user_idx ON withdrawal_requests(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS withdrawal_requests_status_idx ON withdrawal_requests(status, created_at DESC);
