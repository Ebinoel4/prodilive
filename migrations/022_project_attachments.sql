CREATE TABLE IF NOT EXISTS project_attachments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id uuid NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  sender_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  original_name text NOT NULL,
  stored_name text NOT NULL,
  mime text,
  size bigint,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS project_attachments_job_idx ON project_attachments(job_id,created_at);
