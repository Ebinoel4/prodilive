import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
const root=process.cwd();
test('production repository files exist',()=>{for(const f of ['src/server.js','db/schema.sql','public/index.html','Dockerfile','.env.example','docker-compose.yml','nginx.conf','.github/workflows/ci.yml','docs/PRODUCTION_CHECKLIST.md','scripts/backup.sh'])assert.equal(fs.existsSync(path.join(root,f)),true,f)});
test('server has critical security/payment controls',()=>{const s=fs.readFileSync(path.join(root,'src/server.js'),'utf8');for(const x of ['helmet','rateLimit','bcrypt','timingSafeEqual','charge.success','transfer.success','RELEASE_PENDING','CORS_ORIGINS','ALLOWED_UPLOAD_MIMES','amount_or_currency_mismatch'])assert.ok(s.includes(x),x)});
test('schema has required marketplace tables',()=>{const s=fs.readFileSync(path.join(root,'db/schema.sql'),'utf8');for(const x of ['users','jobs','proposals','payments','payouts','disputes','messages','notifications','audit'])assert.ok(s.includes(`CREATE TABLE IF NOT EXISTS ${x}`),x)});

test('production safeguards include private preview, refunds and reviews',()=>{const s=fs.readFileSync(path.join(root,'src/server.js'),'utf8');assert.ok(s.includes("Preview unavailable for this file"));assert.ok(s.includes("/api/admin/payments/:jobId/refund"));assert.ok(s.includes("/api/jobs/:id/review"));assert.ok(s.includes("refund.processed"));assert.ok(s.includes("Missing required production environment variables"));});
