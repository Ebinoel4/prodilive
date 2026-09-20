-- v5.34 unified marketplace membership and scalable dispute review
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_role_check;
UPDATE users SET role='member' WHERE role IN ('client','talent');
ALTER TABLE users ALTER COLUMN role SET DEFAULT 'member';
ALTER TABLE users ADD CONSTRAINT users_role_check CHECK(role IN ('member','reviewer','admin'));
INSERT INTO settings(key,value) VALUES('reviewerAutoResolveLimit','100000'::jsonb) ON CONFLICT (key) DO NOTHING;
