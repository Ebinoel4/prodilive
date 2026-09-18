-- Reviewer applications can now exist before any user account is created:
-- someone applies with just their name, email, experience, and a document +
-- selfie upload. No password, no login yet. An admin reviews it, and only
-- once approved does the applicant get emailed a link to set a password and
-- actually create their account.
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
