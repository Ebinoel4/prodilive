-- Allow a soft-deleted account status, and add provider identity-verification fields.
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_status_check;
ALTER TABLE users ADD CONSTRAINT users_status_check CHECK (status IN ('ACTIVE','SUSPENDED','DELETED'));

ALTER TABLE users ADD COLUMN IF NOT EXISTS verification_doc_name text;
ALTER TABLE users ADD COLUMN IF NOT EXISTS verification_status text NOT NULL DEFAULT 'NONE';
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_verification_status_check;
ALTER TABLE users ADD CONSTRAINT users_verification_status_check CHECK (verification_status IN ('NONE','PENDING','APPROVED','REJECTED'));
ALTER TABLE users ADD COLUMN IF NOT EXISTS verification_submitted_at timestamptz;
ALTER TABLE users ADD COLUMN IF NOT EXISTS verification_reviewed_at timestamptz;
