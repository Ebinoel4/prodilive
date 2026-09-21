# PRODILIVE v5.47
- Removed Become a Reviewer from normal/public navigation and footer; reviewer application is exposed from registration only.
- Added HTTP byte-range streaming for Cloudflare R2 media so HTML5 audio players can play/seek protected previews and project audio correctly.
- Delivery/revision submissions accept up to 25 files per submission and can use a different file count on each revision.
- Assigned talent can delete individual delivery/revision files before final release; objects are deleted from R2 as well as the database.
- Project-file senders can delete their own shared attachments; R2 object is deleted too.
- If all files in a client-review delivery are removed, the job returns to revision-requested instead of leaving an empty review.
