# Persistent file storage (fixing "file not found" after redeploys)

## The problem
Render's free (and most standard) web services use **ephemeral local disk**.
Anything written to the filesystem — uploaded ID documents, selfies, job
deliverable files — is wiped every time the service redeploys or restarts.
The database (Postgres) is separate and persists fine; it's only files
saved directly on disk that disappear. This is why an admin clicking
"View document" on an ID verification submitted a few deploys ago shows
"could not load document" — the database still has a record of the
filename, but the actual file is gone.

## The fix: Cloudflare R2 (free, S3-compatible)
As of this version, if you set `S3_BUCKET` (and the other `S3_*` vars
below), verification documents and selfies are stored in external object
storage instead of local disk, and survive every redeploy. Leave them
unset and nothing breaks — it just falls back to local disk as before
(temporary, not durable).

Cloudflare R2 is a good free option: 10GB storage free, no charge for
outbound bandwidth (most S3-compatible providers charge for downloads;
R2 doesn't).

### Setup steps
1. Sign up / log in at https://dash.cloudflare.com → **R2** in the sidebar.
2. Create a bucket (e.g. `prodilive-uploads`).
3. Go to **Manage R2 API Tokens** → create a token with read/write access
   to that bucket. Copy the **Access Key ID** and **Secret Access Key** —
   R2 only shows the secret once.
4. Find your R2 **endpoint URL** on the bucket's page (looks like
   `https://<account-id>.r2.cloudflarestorage.com`).
5. On Render → your service → **Environment**, add:
   ```
   S3_BUCKET=prodilive-uploads
   S3_ENDPOINT=https://<account-id>.r2.cloudflarestorage.com
   S3_ACCESS_KEY_ID=<from step 3>
   S3_SECRET_ACCESS_KEY=<from step 3>
   S3_REGION=auto
   ```
6. Save — Render redeploys automatically.

Once that's set, verification uploads go straight to R2, and admin's
"View document"/"View selfie" buttons stream the file back from there —
it'll survive every future redeploy.

## What this round does NOT yet cover
Job deliverable files (the originals/previews providers upload when
delivering work) still use local disk only, so they have the same
ephemeral-storage risk. That's a larger change (more upload paths, plus
the preview-generation step) — say the word and I'll extend the same R2
setup to cover those too.

## If you'd rather not set this up right now
Nothing breaks — the app keeps working exactly as it does today, on local
disk. It just means any document a provider uploads before your *next*
deploy will need to be re-uploaded after that deploy, and so on, until R2
(or another persistent option) is configured.
