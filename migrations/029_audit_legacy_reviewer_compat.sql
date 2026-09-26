-- v5.60.5: make Admin Audit Log compatible with older Prodilive databases.
CREATE TABLE IF NOT EXISTS audit (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  action text NOT NULL,
  actor text,
  meta jsonb NOT NULL DEFAULT '{}'::jsonb,
  at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE audit ADD COLUMN IF NOT EXISTS action text;
ALTER TABLE audit ADD COLUMN IF NOT EXISTS actor text;
ALTER TABLE audit ADD COLUMN IF NOT EXISTS meta jsonb NOT NULL DEFAULT '{}'::jsonb;
ALTER TABLE audit ADD COLUMN IF NOT EXISTS at timestamptz NOT NULL DEFAULT now();
CREATE INDEX IF NOT EXISTS audit_at_idx ON audit(at DESC);
