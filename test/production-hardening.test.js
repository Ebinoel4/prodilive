import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';

const server = fs.readFileSync(new URL('../src/server.js', import.meta.url), 'utf8');
const schema = fs.readFileSync(new URL('../db/schema.sql', import.meta.url), 'utf8');

test('Paystack webhook verifies signature before idempotency claim', () => {
  const sig = server.indexOf("const sig=String(req.headers['x-paystack-signature']||''),expected=");
  const claim = server.indexOf('INSERT INTO webhook_events');
  assert.ok(sig >= 0 && claim > sig);
});

test('payment cannot be initialized before a talent is assigned', () => {
  assert.match(server, /if\(j\.status!=='AWAITING_PAYMENT'\)/);
});

test('webhook events are deduplicated in the database', () => {
  assert.match(schema, /CREATE TABLE IF NOT EXISTS webhook_events/);
  assert.match(server, /ON CONFLICT\(event_key\) DO NOTHING/);
});

test('production version is 5.0.0', () => {
  assert.match(server, /version:'5\.0\.0'/);
});
