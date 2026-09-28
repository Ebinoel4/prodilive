// Paystack refund webhook amounts are in kobo; stored payment amounts are in naira.
export function classifyRefundEvent(eventName, amountKobo, paymentAmountNaira) {
  const refundedKobo = Number(amountKobo);
  const originalKobo = Math.round(Number(paymentAmountNaira) * 100);
  if (!Number.isSafeInteger(refundedKobo) || refundedKobo <= 0 ||
      !Number.isSafeInteger(originalKobo) || originalKobo <= 0 || refundedKobo > originalKobo) return null;
  const full = refundedKobo === originalKobo;
  const status = eventName === 'refund.processed' ? (full ? 'REFUNDED' : 'PARTIAL_REFUND') :
    eventName === 'refund.failed' ? 'REFUND_FAILED' :
    (full ? 'REFUND_PROCESSING' : 'PARTIAL_REFUND_PROCESSING');
  return { refundedKobo, full, status };
}
