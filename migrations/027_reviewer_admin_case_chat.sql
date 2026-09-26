-- v5.60.2: private Reviewer ↔ Admin case chat tied to an assigned dispute.
CREATE TABLE IF NOT EXISTS reviewer_admin_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  dispute_id uuid NOT NULL REFERENCES disputes(id) ON DELETE CASCADE,
  sender_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  sender_role text NOT NULL CHECK (sender_role IN ('admin','reviewer')),
  body text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS reviewer_admin_messages_dispute_idx ON reviewer_admin_messages(dispute_id,created_at);
