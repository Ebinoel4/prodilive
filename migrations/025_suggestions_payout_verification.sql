ALTER TABLE users ADD COLUMN IF NOT EXISTS payout_account_verified boolean NOT NULL DEFAULT false;
ALTER TABLE users ADD COLUMN IF NOT EXISTS payout_account_verified_at timestamptz;

-- Existing payout details were saved only after Paystack account-name resolution in prior builds.
UPDATE users SET payout_account_verified=true, payout_account_verified_at=COALESCE(payout_account_verified_at,now())
WHERE bank_code IS NOT NULL AND account_number IS NOT NULL AND account_name IS NOT NULL AND payout_account_verified=false;

CREATE TABLE IF NOT EXISTS suggestions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE SET NULL,
  name text,
  email text,
  body text NOT NULL,
  status text NOT NULL DEFAULT 'NEW',
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS suggestions_created_idx ON suggestions(created_at DESC);
