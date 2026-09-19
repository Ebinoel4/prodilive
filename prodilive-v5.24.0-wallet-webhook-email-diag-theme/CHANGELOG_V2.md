# PRODILIVE v5.1.0 — Marketplace V2 (Phase 1 + partial Phase 2/3/5)

This change set was built against the existing v5.0.0 codebase, following the
phased roadmap in the product spec. It is **additive only** — no existing
table was altered or dropped, no existing endpoint's behavior changed, and the
Paystack payment/payout code paths were not touched.

## What was already there (before this change)

Worth knowing before reading the rest of this: the v5.0.0 backend already had
most of "Phase 3 — Jobs" and "Phase 5 — Trust" built and working — job posting,
open marketplace + direct hire, proposals, protected file delivery with locked
masters, QA review, revisions, single-payment-per-job via Paystack (init,
verify, webhook), disputes with anonymous reviewer assignment and decisions,
reviewer applications + qualification scoring, payouts, admin panel, audit
log, messaging, notifications, and reviews. This change set builds on top of
that rather than rebuilding it.

## Added in this pass

**Phase 1 — Homepage/UI redesign**
- Nav: added Find Work, Pricing
- Homepage: Explore-categories grid, 5-step How It Works, Post-a-Project CTA
  band, Protection section, For Providers section, pricing teaser, final CTA
- New Pricing page (Free described accurately; Pro marked "Coming soon" —
  see "Explicitly not built" below)
- Expanded footer to multi-column

**Phase 2 — Multi-specialty profiles (no schema change)**
- Predefined specialty taxonomy (Production, Musicians, Vocals, Visual &
  Creative) as a multi-select chip picker in the profile editor, replacing
  the old free-text comma field
- "Primary specialty" selector — reorders the existing `skills` array so the
  chosen one is first; talent cards and profile pages already used
  `skills[0]` as the headline role, so this is consistent everywhere
- No new column or migration needed for this part — it reuses the existing
  `users.skills` array

**Packaged services ("I'll mix your song for ₦X")**
- New `services` table (migration `003_marketplace_v2.sql`)
- Talent: add/list/activate/deactivate services from the dashboard
- Public talent profile: services list with "Order Service"
- Ordering a service creates a normal job and assigns it to the talent,
  reusing the existing job-creation and Paystack funding flow — no new
  payment code was written

**Descriptive milestones**
- New `jobs.milestones` jsonb column (default `[]`), additive
- Optional milestone rows (label + amount) when posting a project, shown as
  a breakdown in the project summary panel
- This is **display-only** — see "Explicitly not built" below

**Reviewer system frontend (backend already existed)**
- "Become a Reviewer" application form in the dashboard, wired to the
  existing `/api/reviewer/apply` endpoint
- Reviewer's own "My Review Queue" panel showing disputes assigned to them,
  with the existing release/refund decision actions
- Admin: qualification score entry to finish the approve → test → certify
  flow, and a new Disputes tab to assign an open dispute to a reviewer

**Mobile bottom navigation**
- Fixed bottom nav (Home / Explore / Jobs / Profile) shown on small screens
  for signed-in users, pure UI addition

## Explicitly not built (and why)

- **Pro subscription billing** — needs real Paystack subscription
  integration. Building and wiring untested billing code against a live
  payment processor risks real financial bugs (double charges, stuck
  subscriptions). The Pricing page is honest about this: Pro is marked
  "Coming soon" rather than faked.
- **True per-milestone payment splitting** — the current milestone feature
  is a visible breakdown only; the job is still funded and released as one
  amount, using the existing tested Paystack flow. Splitting actual charges
  and payouts by milestone means changing the payment state machine, which
  needs dedicated design and testing against Paystack directly — not
  something to do blind in this pass.
- **Studio/agency team accounts, recommendations engine, analytics
  dashboards, native mobile apps** (Phase 6) — genuinely separate, large
  subsystems, out of scope for this pass.

## To deploy

1. Run the new migration against your database:
   ```bash
   psql "$DATABASE_URL" -f migrations/003_marketplace_v2.sql
   ```
2. Replace `src/server.js` and `public/index.html` with the versions in this
   package (or diff/merge if you've made local changes since the zip you
   provided).
3. Deploy as usual (git push if Render is connected to your repo).
4. Smoke-test: post a project with a milestone, list a service as a talent
   account, order it as a client, and check the admin Disputes tab shows
   existing disputes correctly.

## v5.2.0 — Dedicated Reviewer Application & Hub

- New public "Become a Reviewer" page (`reviewerApply` view) reachable from nav/footer without requiring login first — explains the role, shows a 3-step process, and hosts the application form (specialty picker, experience, portfolio links) once signed in.
- Shows live application status (Pending / Qualification / Approved / Rejected-can-reapply) by calling a new endpoint.
- New backend endpoint: `GET /api/reviewer/my-application` — returns the signed-in user's latest reviewer application (additive, no schema change).
- New dedicated Reviewer Hub (`reviewerHub` view) — a separate dashboard for reviewer-role users distinct from the shared client/talent dashboard. Shows assigned case queue, resolved case history, qualification score/level, and profile editing.
- Nav bar is now role-aware: reviewers see "Reviewer Hub" instead of "Dashboard" in both desktop nav and after login; non-reviewers still see "Become a Reviewer".
- Removed the old embedded reviewer-application mini-form from the shared dashboard (client/talent still see a "Learn more & apply" shortcut into the new page, avoiding duplicate forms).
- Reviewers logging in via the old generic Dashboard route are auto-redirected to the Reviewer Hub.

## v5.3.0 — Messaging & Support Chat

**Project chat (client ↔ provider ↔ reviewer, per job)**
- Restyled the existing job-thread messages into real chat bubbles (own messages right-aligned/brass, others left-aligned)
- Auto-scrolls to latest message; Enter sends, Shift+Enter adds a newline
- Live polling every 6s while a job's chat panel is open (no full page reload) — messages arrive without refreshing

**Site-wide support chat widget**
- New floating chat bubble on every page, for logged-in users and anonymous visitors alike
- Guests get a persistent thread via a token stored in their browser, so returning visitors see their conversation history
- Logged-in users' threads are tied to their account automatically
- New DB tables (additive, migration 004): `support_threads`, `support_messages`
- New endpoints: `POST /api/support/message`, `GET /api/support/thread/:id`, plus admin-only `GET /api/admin/support`, `GET /api/admin/support/:id`, `POST /api/admin/support/:id/reply`, `POST /api/admin/support/:id/close`
- New **Support Chat** tab in the Admin dashboard — lists all conversations, lets staff open a thread and reply in the same bubble UI, and close resolved conversations
- Logged-in visitors get a notification when support replies

## v5.4.0 — Verification, Protected Audio, Full Marketplace, Real-Time Feed

**Email verification enforcement (closes the fake-email signup hole)**
- New accounts start `email_verified: false`; verifying via the emailed link now flips this flag
- Disposable/temp-mail domains (Mailinator, Guerrilla Mail, 10minutemail, etc.) are rejected at signup
- Unverified users are blocked from: posting jobs, applying to jobs, sending messages, initializing payments, ordering services, applying as reviewer, and listing/buying marketplace products
- Dashboard shows a warning banner + "Resend verification email" for unverified accounts
- **Deployment requirement:** `SMTP_HOST`, `SMTP_USER`, `SMTP_PASS` (and related) must be set in your Render environment for verification emails to actually send — without SMTP configured, accounts stay unverified and blocked, which is safe but means real users may get stuck. Configure SMTP before relying on this.

**Protected audio delivery**
- Preview generation (ffmpeg) now mixes in an audible periodic watermark tone, not just a metadata tag
- Frontend previews now play through a locked-down embedded `<audio>` player (no direct download link, no right-click "Save As" via `controlsList="nodownload"`, context menu disabled) instead of the old raw file link
- Master file download stays gated exactly as before: only the client, only after the job status is `RELEASED`

**Full marketplace for musicians — beats, tracks, templates, sample packs**
- New `products` / `product_orders` tables and full API: list, browse/search/filter by category, buy via Paystack, gated download only after purchase (or for the seller)
- New "Beats & Templates" section in nav (desktop, mobile, footer) and homepage
- Any verified user can list a product via a new "Sell your work" modal (file upload + price + license terms)
- Product previews use the same watermarked-preview pipeline as job deliverables

**Real-time live feed**
- Socket.IO added to the server; new job posts and new marketplace listings broadcast instantly to everyone browsing
- New "First come, first served" toggle when posting a job — any provider can instantly claim it (atomic, race-safe — whoever's request lands first in the database wins, others get a friendly "already claimed" message)
- Claimed jobs update live for everyone else viewing the list, without a refresh

**Deploy notes**
- Run migration `005_verification_marketplace_realtime.sql` (additive, safe on live DB)
- `npm install` needed — added `socket.io` dependency
- Confirm your hosting platform allows WebSocket connections (Render does by default)

## v5.5.0 — Visual/Professional Polish Pass

- Replaced the tracked-out ALL-CAPS monospace "eyebrow" labels (a common templated-AI-design tell) across every page with a quieter italic serif treatment in the brand's own Fraunces typeface — same function, more considered look
- Converted all hardcoded ALL-CAPS section labels to sentence case to match
- Added a real hero visual: an animated brass equalizer/waveform graphic on the homepage — grounded in the actual subject matter (music) rather than a generic gradient or stock illustration; respects `prefers-reduced-motion`
- Modals now have a subtle rise-in entrance animation, drop shadow, and a brass accent line — one deliberate motion moment rather than scattered hover effects everywhere
- Homepage restructured into a two-column hero (copy + waveform) on desktop, stacking cleanly on mobile

Note: this was a scoped, high-impact polish pass rather than a ground-up rebuild — the existing brass/dark palette, Fraunces/Sora/Plex Mono type system, and page structure (hero → categories → how it works → featured talent → trust → CTA → pricing) were already distinctive and functional, so the redesign focused on removing template "tells" and adding one memorable visual moment rather than discarding a working design.
