-- v5.58: reviewer onboarding is application -> admin test -> private invite -> account -> ID -> terms -> active
ALTER TABLE users ADD COLUMN IF NOT EXISTS reviewer_terms_accepted_at timestamptz;
ALTER TABLE users ADD COLUMN IF NOT EXISTS reviewer_terms_version text;
