# v5.18.0 — Site-wide audit: missing buttons found and fixed

Did a full pass cross-referencing every clickable element against the
functions and API endpoints that back them. Good news: every `onclick`,
`onchange`, and `onsubmit` handler on the site already points to a real,
working function — there were no "dead" buttons calling something that
doesn't exist.

The actual problem was different and more important: **several backend
features had no button anywhere to trigger them at all.** These weren't
broken clicks — they were entire admin capabilities you had no way to
reach through the UI.

## The big one: providers were never getting paid
`/api/admin/payouts/:jobId/release` — the endpoint that actually sends
money to a provider via Paystack once a client approves their work — had
**zero UI anywhere on the site.** A job could sit in "payout pending"
forever with no button for you to release it. Same for issuing a refund.

**Fixed:** the admin Payments tab now shows a **Release payout** button on
any job that's ready, and a **Refund** button on any refundable payment.

## Also fixed
- **No way to view the audit log.** Every admin/system action has been
  recorded to an audit table since early versions, but there was no tab to
  see it. Added an **Audit Log** tab.
- **No way to change platform settings.** Commission percentage, client
  review window, and auto-approve timing were only editable by hand-crafting
  an API request. Added a **Settings** tab.

## Found, not yet fixed — a real gap, bigger than a bug
The **products/beats marketplace** (the part where a provider sells fixed-
price items like beats or sample packs, separate from custom jobs) has a
fully working backend — create a listing, buy it, seller order history —
but **no frontend for any of it except browsing and buying**. There's no
button anywhere for a provider to actually list a product, and no "My
Purchases" page for a buyer to see what they've bought. This isn't a
broken button so much as a feature that's half-built — building the seller
listing form + order dashboards is a real chunk of work on its own. Tell me
if you want that built out next.

## Deploy steps
Just push — no migration, no env var changes.
