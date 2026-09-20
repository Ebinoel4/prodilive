# Prodilive v5.35 — Dedicated Paystack Business

- Prodilive now treats its Paystack integration as a dedicated business integration.
- Paystack job payments are tagged with `platform: PRODILIVE` metadata.
- Paystack wallet deposits are tagged with `platform: PRODILIVE` metadata.
- Incoming Prodilive Paystack webhooks are no longer forwarded to a secondary website.
- Existing completed wallet ledger entries remain untouched when the Paystack API key is changed.
- Existing manual withdrawal workflow remains unchanged.

Deployment: replace `PAYSTACK_SECRET_KEY` in Render with the new Prodilive business live secret key, configure the new business webhook as `https://www.prodilive.com/api/paystack/webhook`, then redeploy.
