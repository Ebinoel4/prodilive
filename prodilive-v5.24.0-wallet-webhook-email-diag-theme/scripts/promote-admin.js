// Promote an already-registered user to admin, without needing to touch
// ADMIN_EMAIL/ADMIN_PASSWORD or create a brand new account.
//
// Usage (run on the same host/env as the app, so DATABASE_URL is available):
//   node scripts/promote-admin.js you@yourdomain.com
//
import 'dotenv/config';
import { Pool } from 'pg';

const email = String(process.argv[2] || '').trim().toLowerCase();
if (!email) {
  console.error('Usage: node scripts/promote-admin.js <email>');
  process.exit(1);
}

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
});

try {
  const existing = await pool.query('SELECT id, role, status FROM users WHERE email=$1', [email]);
  if (!existing.rowCount) {
    console.error(`No user found with email ${email}. Register the account on the site first, then re-run this script.`);
    process.exit(1);
  }
  const r = await pool.query(
    "UPDATE users SET role='admin', status='ACTIVE', email_verified=true WHERE email=$1 RETURNING id, name, email, role",
    [email]
  );
  console.log('Promoted to admin:', r.rows[0]);
} finally {
  await pool.end();
}
