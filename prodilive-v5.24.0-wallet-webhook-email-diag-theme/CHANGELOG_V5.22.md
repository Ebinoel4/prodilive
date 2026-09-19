# v5.22.0 — Profile page, My Purchases, reviewer isolation, preview rebuild

## New pages
- **Profile** (nav link): name, nickname, phone, address, bio, etc. all
  editable in one place, plus a **Change Password** form (current password
  required, logs out every other active session on change).
- **My Purchases** (nav link, hidden for reviewers/admin): every beat/
  template you've bought, with a working **Download** button. The backend
  already supported this; it just had no page before.
- **Terms & Conditions** (footer link): on-platform-only policy, escrow,
  fraud/misrepresentation consequences, reviewer conduct, wallet fees.

## Fixed
- **Download button was broken** — it used a plain link with no auth
  token, so it would 401 even after a successful purchase. Now does an
  authenticated fetch + real file download.
- **"Become a Reviewer" still showed to logged-in clients/providers** — the
  nav link's visibility logic had a bug; it now only shows when logged out.
- **Reviewers couldn't view the job behind their own assigned dispute** —
  a real pre-existing bug in the job-detail endpoint's access check, now
  fixed.
- **ID verification "insufficient permission"** — very likely you tested
  with a non-provider account (this is talent-only by design). Improved
  the error message to say so explicitly instead of a generic permissions
  error.

## Reviewer isolation
- Reviewers no longer see Find Talent / Find Work / Beats & Templates in
  navigation.
- Reviewers are blocked server-side (not just hidden in the UI) from
  purchasing marketplace listings.
- Admin now gets an **instant alert** the moment a reviewer resolves a
  dispute and funds start moving — not a blocking pre-approval (that would
  reintroduce the bottleneck removed earlier), but immediate visibility so
  you can step in fast if something looks wrong.

## Wallet display
Now shows balance, total deposited, total earned (providers), and total
withdrawn — not just the current balance.

## Beat preview rebuild — please test this one carefully
The old preview generator had a real ffmpeg argument-ordering bug that
made output length unpredictable (you saw ~2 seconds; it could just as
easily have run long). Rebuilt it to:
- Trim every preview to a consistent ~40 seconds
- Loop a spoken **"This is a protected preview from prodilive dot com"**
  watermark roughly every 9 seconds, generated with `espeak-ng` (added to
  the Dockerfile)
- Fall back to the old tone-based watermark automatically if speech
  generation isn't available on the host for any reason

**Being direct about risk**: I don't have ffmpeg or espeak-ng available to
test this pipeline in my own environment, so this is my best correct
construction of the command, not a verified one. After deploying, please
upload a fresh test beat and listen to the preview end-to-end. If it
sounds wrong (garbled, wrong length, no watermark, or upload fails), send
me exactly what you hear/see and I'll fix it fast — Render's Logs tab will
also show a line starting with `preview` if the generation step itself
errors out.

## Deploy steps
Push and redeploy — `migrations/*.sql` auto-apply (none new this round),
but note the **Dockerfile changed** (added `espeak-ng`), so this deploy
will take a bit longer than usual as Render rebuilds the image from
scratch.
