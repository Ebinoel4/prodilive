CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE IF NOT EXISTS users (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name text NOT NULL, email text UNIQUE NOT NULL, password_hash text NOT NULL,
 role text NOT NULL DEFAULT 'client' CHECK(role IN ('client','talent','reviewer','admin')), status text NOT NULL DEFAULT 'ACTIVE' CHECK(status IN ('ACTIVE','SUSPENDED')),
 bio text, avatar_url text, skills text[] NOT NULL DEFAULT '{}', portfolio jsonb NOT NULL DEFAULT '[]', bank_code text, account_number text,
 paystack_recipient_code text, reviewer_score numeric, reviewer_level text, created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS webhook_events (event_key text PRIMARY KEY, provider text NOT NULL, event_type text NOT NULL, payload jsonb NOT NULL DEFAULT '{}', created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS sessions (token_hash text PRIMARY KEY,user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,expires_at timestamptz NOT NULL,ip text,user_agent text,created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS email_verifications (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,token_hash text UNIQUE NOT NULL,expires_at timestamptz NOT NULL,verified_at timestamptz);
CREATE TABLE IF NOT EXISTS password_resets (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,token_hash text UNIQUE NOT NULL,expires_at timestamptz NOT NULL,used_at timestamptz);
CREATE TABLE IF NOT EXISTS jobs (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),client_id uuid NOT NULL REFERENCES users(id),talent_id uuid REFERENCES users(id),title text NOT NULL,description text NOT NULL,budget numeric(14,2) NOT NULL CHECK(budget>0),currency text NOT NULL DEFAULT 'NGN',category text,deadline timestamptz,
 revision_count int NOT NULL DEFAULT 2 CHECK(revision_count>=0),revisions_used int NOT NULL DEFAULT 0,deliverables jsonb NOT NULL DEFAULT '[]',acceptance_criteria jsonb NOT NULL DEFAULT '[]',reference_urls jsonb NOT NULL DEFAULT '[]',
 status text NOT NULL DEFAULT 'OPEN',payment_status text NOT NULL DEFAULT 'UNPAID',payment_reference text,funded_at timestamptz,submitted_at timestamptz,approved_at timestamptz,review_deadline timestamptz,revision_reason text,submission_id uuid,qa jsonb,resolution jsonb,payout_reference text,created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS proposals (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),job_id uuid NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,talent_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,message text NOT NULL DEFAULT '',quote numeric(14,2),status text NOT NULL DEFAULT 'PENDING',created_at timestamptz NOT NULL DEFAULT now(),UNIQUE(job_id,talent_id));
CREATE TABLE IF NOT EXISTS files (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),job_id uuid NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,submission_id uuid NOT NULL,original_name text NOT NULL,stored_name text NOT NULL UNIQUE,mime text,size bigint NOT NULL,sha256 text NOT NULL,preview_name text,access text NOT NULL DEFAULT 'PRIVATE_MASTER',created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS payments (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),job_id uuid NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,reference text UNIQUE NOT NULL,amount numeric(14,2) NOT NULL,currency text NOT NULL DEFAULT 'NGN',provider text NOT NULL DEFAULT 'PAYSTACK',status text NOT NULL,paid_at timestamptz,provider_payload jsonb,created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS payouts (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),job_id uuid NOT NULL REFERENCES jobs(id) UNIQUE,talent_id uuid NOT NULL REFERENCES users(id),amount numeric(14,2) NOT NULL,reference text UNIQUE,status text,provider_payload jsonb,created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS disputes (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),job_id uuid NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,opened_by uuid NOT NULL REFERENCES users(id),reason text NOT NULL,evidence jsonb NOT NULL DEFAULT '[]',status text NOT NULL DEFAULT 'OPEN',assigned_reviewer_id uuid REFERENCES users(id),decision jsonb,created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS reviewer_applications (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,specialties jsonb NOT NULL DEFAULT '[]',experience text,portfolio jsonb NOT NULL DEFAULT '[]',references_json jsonb NOT NULL DEFAULT '[]',status text NOT NULL DEFAULT 'PENDING',reviewed_by uuid REFERENCES users(id),reviewed_at timestamptz,created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS reviewer_tests (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),application_id uuid UNIQUE NOT NULL REFERENCES reviewer_applications(id) ON DELETE CASCADE,user_id uuid NOT NULL REFERENCES users(id),status text NOT NULL DEFAULT 'PENDING',score numeric,created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS messages (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),job_id uuid NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,sender_id uuid NOT NULL REFERENCES users(id),body text NOT NULL,created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS reviews (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),job_id uuid NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,reviewer_id uuid NOT NULL REFERENCES users(id),reviewee_id uuid NOT NULL REFERENCES users(id),rating int NOT NULL CHECK(rating BETWEEN 1 AND 5),comment text NOT NULL DEFAULT '',created_at timestamptz NOT NULL DEFAULT now(),UNIQUE(job_id,reviewer_id));
CREATE INDEX IF NOT EXISTS reviews_reviewee_idx ON reviews(reviewee_id,created_at DESC);
CREATE TABLE IF NOT EXISTS notifications (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,type text NOT NULL,title text NOT NULL,body text NOT NULL,meta jsonb NOT NULL DEFAULT '{}',read_at timestamptz,created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS audit (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),action text NOT NULL,actor text,meta jsonb NOT NULL DEFAULT '{}',at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS settings (key text PRIMARY KEY,value jsonb NOT NULL);
INSERT INTO settings(key,value) VALUES('commission','12'),('reviewWindowHours','48'),('autoApproveHours','72') ON CONFLICT DO NOTHING;
CREATE INDEX IF NOT EXISTS webhook_events_created_idx ON webhook_events(created_at DESC);CREATE INDEX IF NOT EXISTS sessions_user_idx ON sessions(user_id);CREATE INDEX IF NOT EXISTS sessions_expiry_idx ON sessions(expires_at);CREATE INDEX IF NOT EXISTS jobs_client_idx ON jobs(client_id);CREATE INDEX IF NOT EXISTS jobs_talent_idx ON jobs(talent_id);CREATE INDEX IF NOT EXISTS jobs_status_idx ON jobs(status);CREATE INDEX IF NOT EXISTS jobs_category_idx ON jobs(category);CREATE INDEX IF NOT EXISTS proposals_job_idx ON proposals(job_id);CREATE INDEX IF NOT EXISTS files_job_idx ON files(job_id);CREATE INDEX IF NOT EXISTS payments_job_idx ON payments(job_id);CREATE INDEX IF NOT EXISTS disputes_job_idx ON disputes(job_id);CREATE INDEX IF NOT EXISTS messages_job_idx ON messages(job_id);CREATE INDEX IF NOT EXISTS notifications_user_idx ON notifications(user_id,created_at DESC);CREATE INDEX IF NOT EXISTS audit_at_idx ON audit(at DESC);
-- 004_support_chat.sql
-- Additive only: no existing columns/tables are altered or dropped.
-- Safe to run on the live database.

-- A support conversation. Belongs to a logged-in user (user_id set) or a
-- guest visitor (guest_token set, generated client-side and stored in
-- localStorage so they can return to the same thread).
CREATE TABLE IF NOT EXISTS support_threads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE SET NULL,
  guest_token text,
  guest_name text,
  guest_email text,
  status text NOT NULL DEFAULT 'OPEN',
  created_at timestamptz NOT NULL DEFAULT now(),
  CHECK (user_id IS NOT NULL OR guest_token IS NOT NULL)
);
CREATE INDEX IF NOT EXISTS idx_support_threads_user ON support_threads(user_id);
CREATE INDEX IF NOT EXISTS idx_support_threads_guest ON support_threads(guest_token);
CREATE INDEX IF NOT EXISTS idx_support_threads_status ON support_threads(status);

CREATE TABLE IF NOT EXISTS support_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  thread_id uuid NOT NULL REFERENCES support_threads(id) ON DELETE CASCADE,
  sender_type text NOT NULL CHECK (sender_type IN ('visitor','admin')),
  sender_name text NOT NULL DEFAULT '',
  body text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_support_messages_thread ON support_messages(thread_id, created_at);
-- 005_verification_marketplace_realtime.sql
-- Additive only — safe to run on the live database.

-- Email verification enforcement
ALTER TABLE users ADD COLUMN IF NOT EXISTS email_verified boolean NOT NULL DEFAULT true;
-- (default true preserves access for all EXISTING accounts; new registrations
-- explicitly insert false at the application layer, see server.js)

-- Instant-claim ("first to accept wins") jobs
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS instant_claim boolean NOT NULL DEFAULT false;

-- Digital products: beats, tracks, sample packs, production templates
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  seller_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text NOT NULL DEFAULT '',
  category text NOT NULL DEFAULT 'BEAT' CHECK (category IN ('BEAT','TRACK','TEMPLATE','SAMPLE_PACK','OTHER')),
  price numeric(12,2) NOT NULL CHECK (price >= 0),
  license_terms text NOT NULL DEFAULT 'Standard non-exclusive license',
  master_file_name text,
  master_original_name text,
  master_mime text,
  preview_file_name text,
  cover_image_url text,
  active boolean NOT NULL DEFAULT true,
  sales_count integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_products_seller ON products(seller_id);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_active ON products(active);

CREATE TABLE IF NOT EXISTS product_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  buyer_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  seller_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  amount numeric(12,2) NOT NULL,
  reference text UNIQUE NOT NULL,
  status text NOT NULL DEFAULT 'INITIALIZED' CHECK (status IN ('INITIALIZED','PAID','FAILED')),
  provider_payload jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  paid_at timestamptz
);
CREATE INDEX IF NOT EXISTS idx_product_orders_buyer ON product_orders(buyer_id);
CREATE INDEX IF NOT EXISTS idx_product_orders_product ON product_orders(product_id);
