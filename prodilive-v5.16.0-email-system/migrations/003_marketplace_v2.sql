-- 003_marketplace_v2.sql
-- Additive only: no existing columns/tables are altered or dropped.
-- Safe to run on the live database; existing rows get sane defaults.

-- Descriptive milestone breakdown for a job (display-only; does NOT change
-- payment/release logic, which continues to operate on jobs.budget as a
-- single funded amount).
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS milestones jsonb NOT NULL DEFAULT '[]'::jsonb;

-- Packaged services a talent can list on their profile ("I'll mix your
-- song for X"). Ordering a service creates a normal job under the hood
-- and reuses the existing job + assignment + payment flow, so no new
-- payment code paths are introduced.
CREATE TABLE IF NOT EXISTS services (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  talent_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text NOT NULL DEFAULT '',
  price numeric NOT NULL CHECK (price > 0),
  delivery_days integer NOT NULL DEFAULT 5,
  revision_count integer NOT NULL DEFAULT 2,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_services_talent ON services(talent_id);
CREATE INDEX IF NOT EXISTS idx_services_active ON services(active) WHERE active;
