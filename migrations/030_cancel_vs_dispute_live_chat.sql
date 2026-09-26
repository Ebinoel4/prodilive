-- v5.61.0: separate no-fault "cancellation" flow from arbitrated "dispute" flow,
-- track repeat-cancellation abuse, and support live chat push.
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS kind text NOT NULL DEFAULT 'DISPUTE';
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS requires_reviewer boolean NOT NULL DEFAULT true;
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS counterparty_response text;
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS counterparty_responded_at timestamptz;
CREATE INDEX IF NOT EXISTS idx_disputes_opened_by_kind_created ON disputes(opened_by, kind, created_at);
INSERT INTO settings(key,value) VALUES('softCancelMonthlyLimit','3'::jsonb) ON CONFLICT (key) DO NOTHING;
