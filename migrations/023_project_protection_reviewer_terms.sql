CREATE TABLE IF NOT EXISTS account_flags (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  job_id uuid REFERENCES jobs(id) ON DELETE SET NULL,
  kind text NOT NULL,
  evidence text,
  status text NOT NULL DEFAULT 'OPEN',
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE reviewer_applications ADD COLUMN IF NOT EXISTS terms_accepted_at timestamptz;
ALTER TABLE reviewer_applications ADD COLUMN IF NOT EXISTS terms_version text;
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS cancellation_code text;
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS suggested_talent_percent numeric(5,2);
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS client_voluntary_percent numeric(5,2);
