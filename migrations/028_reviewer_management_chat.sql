-- v5.60.3: general Admin ↔ Reviewer messaging independent of a specific dispute.
CREATE TABLE IF NOT EXISTS reviewer_admin_direct_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reviewer_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  sender_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  sender_role text NOT NULL CHECK (sender_role IN ('admin','reviewer')),
  body text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS reviewer_admin_direct_messages_idx ON reviewer_admin_direct_messages(reviewer_id,created_at);
