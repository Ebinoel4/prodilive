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
