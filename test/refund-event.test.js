import test from 'node:test';
import assert from 'node:assert/strict';
import { classifyRefundEvent } from '../src/refund-event.js';

test('partial refund remains partial at every webhook stage', () => {
  assert.deepEqual(classifyRefundEvent('refund.processed', 250000, 10000),
    { refundedKobo: 250000, full: false, status: 'PARTIAL_REFUND' });
  assert.equal(classifyRefundEvent('refund.pending', 250000, 10000).status, 'PARTIAL_REFUND_PROCESSING');
});
test('full refund is distinguished from partial refund', () => {
  assert.equal(classifyRefundEvent('refund.processed', 1000000, 10000).status, 'REFUNDED');
});
test('missing, excessive, and malformed amounts are rejected', () => {
  for (const amount of [undefined, 'nonsense', -1, 1000001])
    assert.equal(classifyRefundEvent('refund.processed', amount, 10000), null);
});
