CREATE TABLE IF NOT EXISTS platform_ledger (
  id bigserial PRIMARY KEY,
  type text NOT NULL,
  amount numeric(14,2) NOT NULL,
  reference text NOT NULL UNIQUE,
  status text NOT NULL DEFAULT 'COMPLETED',
  meta jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS auto_cancel_overdue boolean NOT NULL DEFAULT false;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS overdue_grace_hours integer NOT NULL DEFAULT 24;
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS settlement_deadline timestamptz;
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS reviewer_action_deadline timestamptz;
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS reviewer_intervened_at timestamptz;
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS resolved_by_parties_at timestamptz;
