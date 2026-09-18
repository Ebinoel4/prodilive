ALTER TABLE reviewer_applications ALTER COLUMN user_id DROP NOT NULL;
ALTER TABLE reviewer_applications ADD COLUMN IF NOT EXISTS applicant_name text;
ALTER TABLE reviewer_applications ADD COLUMN IF NOT EXISTS applicant_email text;
ALTER TABLE reviewer_applications ADD COLUMN IF NOT EXISTS doc_name text;
ALTER TABLE reviewer_applications ADD COLUMN IF NOT EXISTS doc_type text;
ALTER TABLE reviewer_applications ADD COLUMN IF NOT EXISTS selfie_name text;

CREATE TABLE IF NOT EXISTS reviewer_invites (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  application_id uuid NOT NULL REFERENCES reviewer_applications(id),
  token_hash text NOT NULL UNIQUE,
  expires_at timestamptz NOT NULL,
  used_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);
