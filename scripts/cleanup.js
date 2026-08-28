import 'dotenv/config';
import { Pool } from 'pg';
const pool=new Pool({connectionString:process.env.DATABASE_URL,ssl:process.env.NODE_ENV==='production'?{rejectUnauthorized:false}:false});
try{await pool.query("DELETE FROM sessions WHERE expires_at<=now()");await pool.query("DELETE FROM email_verifications WHERE expires_at<=now() AND verified_at IS NULL");await pool.query("DELETE FROM password_resets WHERE expires_at<=now() OR used_at IS NOT NULL");console.log('cleanup complete')}finally{await pool.end()}
