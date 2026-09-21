# PRODILIVE v5.48 — Audio / media playback fix

**Root cause:** every audio player on the site (delivery previews, shared project files, review stage) used a plain
`<audio src="/api/...">`. Browsers cannot attach the `Authorization: Bearer` header to media tags, so the server answered
401 and the file never played. The same problem broke "Open" on shared files and "Download master".

- New `POST /api/media/sign` — returns a short-lived (4 h), single-file, single-user signed URL (`?mt=`). Protected media
  routes (`/api/files/:id/preview`, `/api/files/:id/master`, `/api/project-attachments/:id/file`) accept it in addition to
  the normal Bearer header. The route's normal permission check still runs, so a token never grants extra access.
- Frontend: `data-media` elements are hydrated automatically with a signed URL; players refresh an expired URL once and, if
  a file still can't play, show the real reason (missing file, unsupported format, ...) instead of a dead player.
- Video files shared in project chat now get an inline video player; other files (PDF, images, docs, zip) open via a fresh signed URL.
- Uploads: delivery files, project attachments and marketplace masters now accept ANY audio (mp3, wav, m4a, aac, flac, ogg,
  opus, aif/aiff, ...), video (mp4, mov, webm, ...), images, PDF, Word/Excel/PowerPoint, text, archives and DAW project files.
  Browsers that report audio as empty / `application/octet-stream` (common for .flac/.aif/.m4a) are recognised by extension and the stored
  type is normalised so it plays everywhere. HTML/SVG/scripts/executables are still rejected. The `ALLOWED_UPLOAD_MIMES` env var can
  no longer accidentally block audio for these routes.
- Fixed: multer's 10-file cap contradicted the 25-file delivery limit — uploading 11–25 files failed.
- Audio/video streaming no longer counts against the 300-requests-per-15-minutes API limit (seeking/buffering makes many
  range requests) — media now has its own 3000/15 min bucket.
- Generated previews are written with `-movflags +faststart` so they start playing immediately.
- Reviewers assigned to a dispute can now play that job's delivery previews and shared project files (they could already read the chat).
- R2 range streams stop reading from storage as soon as the player disconnects or seeks.
- Optional env: `MEDIA_SIGNING_SECRET` (any long random string). If unset, a stable secret is derived from DATABASE_URL + R2 secret.
