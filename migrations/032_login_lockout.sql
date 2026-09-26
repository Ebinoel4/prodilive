-- v5.62.0: per-account login lockout (on top of the existing per-IP rate
-- limit, which alone doesn't stop a distributed/many-IP brute force against
-- one specific account).
ALTER TABLE users ADD COLUMN IF NOT EXISTS failed_login_count int NOT NULL DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS failed_login_locked_until timestamptz;
INSERT INTO settings(key,value) VALUES('loginLockoutThreshold','8'::jsonb) ON CONFLICT (key) DO NOTHING;
INSERT INTO settings(key,value) VALUES('loginLockoutMinutes','15'::jsonb) ON CONFLICT (key) DO NOTHING;
