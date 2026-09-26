-- v5.61.1: idempotent safety-net re-run of the columns the Cancel/Dispute
-- split depends on. Harmless if 030 already applied cleanly; fixes it if 030
-- partially failed on a previous deploy (each statement now also runs
-- independently — see the rewritten migration runner in src/server.js).
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS kind text NOT NULL DEFAULT 'DISPUTE';
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS requires_reviewer boolean NOT NULL DEFAULT true;
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS counterparty_response text;
ALTER TABLE disputes ADD COLUMN IF NOT EXISTS counterparty_responded_at timestamptz;
CREATE INDEX IF NOT EXISTS idx_disputes_opened_by_kind_created ON disputes(opened_by, kind, created_at);
