ALTER TABLE users ADD COLUMN IF NOT EXISTS verification_doc_data bytea;
ALTER TABLE users ADD COLUMN IF NOT EXISTS verification_doc_mime text;
ALTER TABLE users ADD COLUMN IF NOT EXISTS verification_selfie_data bytea;
ALTER TABLE users ADD COLUMN IF NOT EXISTS verification_selfie_mime text;
