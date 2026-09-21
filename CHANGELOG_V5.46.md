# PRODILIVE v5.46 — Cloudflare R2 Only Uploads

- Cloudflare R2 is now the only persistent storage path for user-generated files.
- Removed local-disk persistence fallbacks for verification files, project attachments, job delivery masters/previews, and marketplace masters/previews/covers.
- Multer now uses memory storage, so incoming uploads are not first persisted to Render's upload directory.
- Upload endpoints fail with 503 when R2 is not fully configured instead of silently saving user files locally.
- Download/stream routes read user files from R2 only.
- Product deletion removes associated R2 objects only.
- Audio preview generation may use short-lived processing files for ffmpeg, which are deleted immediately; the source/master and generated preview are persisted only in R2.
