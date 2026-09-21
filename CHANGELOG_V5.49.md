# PRODILIVE v5.49 — Protected Preview + Voice Notes

- Protected delivery/marketplace previews mix a dedicated human-recorded male `Prodilive.com` voice clip every 10 seconds.
- Removed robotic/eSpeak and tone watermark generation/fallback from preview generation.
- Full delivery master remains locked until payment is released/job completes.
- Project chat/reference audio remains unwatermarked and streams inline.
- Added browser voice-note recording to project chat; voice notes are uploaded to Cloudflare R2 as normal protected project attachments.
- Added multiple reference-file selection (up to 10, uploaded individually) and explicit WebM/Opus audio handling.
- Fixed `.webm` voice notes being misclassified as video when the browser correctly reports `audio/webm`.

## Required watermark asset
Place a real human male recording saying exactly `Prodilive.com` at:
`assets/prodilive-watermark-natural-male.wav`

The app intentionally does not fall back to robotic speech. If the asset is absent, audio masters still upload but a protected preview is not generated.
