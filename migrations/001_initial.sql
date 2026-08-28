-- Canonical PRODILIVE PostgreSQL schema. Run once on a new database.
\i ../db/schema.sql

CREATE TABLE IF NOT EXISTS reviews (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),job_id uuid NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,reviewer_id uuid NOT NULL REFERENCES users(id),reviewee_id uuid NOT NULL REFERENCES users(id),rating int NOT NULL CHECK(rating BETWEEN 1 AND 5),comment text NOT NULL DEFAULT '',created_at timestamptz NOT NULL DEFAULT now(),UNIQUE(job_id,reviewer_id));
CREATE INDEX IF NOT EXISTS reviews_reviewee_idx ON reviews(reviewee_id,created_at DESC);
