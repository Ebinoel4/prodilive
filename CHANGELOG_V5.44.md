# PRODILIVE v5.44
- Fixed delivery files that uploaded successfully but errored when opened by storing job masters and generated previews in configured R2/S3 durable object storage.
- Preview/master endpoints now stream from R2/S3 with local-disk fallback for development.
- Added project attachments so both client and assigned talent can share audio/reference files inside the protected project chat.
- Audio attachments are playable inline; other allowed reference files can be opened from the project.
- Added migration 022_project_attachments.sql.
- Updated Multer dependency requirement to patched 2.3.x.
