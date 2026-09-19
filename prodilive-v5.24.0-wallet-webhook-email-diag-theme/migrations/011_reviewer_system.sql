-- Reviewers: separate signup pipeline status (independent of general user status)
ALTER TABLE users ADD COLUMN IF NOT EXISTS reviewer_status text NOT NULL DEFAULT 'ACTIVE';
-- PENDING = just registered as a reviewer, awaiting admin approval
-- QUALIFICATION = approved to take the qualification test
-- ACTIVE = certified/trainee reviewer, can take disputes
-- REJECTED = application declined

-- Reviewer earnings ledger (dispute-resolution fees, separate from talent payouts)
CREATE TABLE IF NOT EXISTS reviewer_ledger (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reviewer_id uuid NOT NULL REFERENCES users(id),
  dispute_id uuid REFERENCES disputes(id),
  job_id uuid REFERENCES jobs(id),
  amount numeric NOT NULL,
  status text NOT NULL DEFAULT 'AVAILABLE' CHECK (status IN ('AVAILABLE','WITHDRAWN','WITHDRAWAL_PROCESSING','WITHDRAWAL_FAILED')),
  reference text,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_reviewer_ledger_reviewer ON reviewer_ledger(reviewer_id, status);

-- Disputes: make sure status supports an open, unclaimed pool
ALTER TABLE disputes DROP CONSTRAINT IF EXISTS disputes_status_check;
ALTER TABLE disputes ADD CONSTRAINT disputes_status_check CHECK (status IN ('OPEN','ASSIGNED','DECIDED'));

INSERT INTO settings(key,value) VALUES('reviewerFeePercent','5') ON CONFLICT DO NOTHING;

