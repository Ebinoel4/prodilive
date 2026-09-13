#!/usr/bin/env bash
set -euo pipefail
: "${DATABASE_URL:?DATABASE_URL is required}"
OUT_DIR="${BACKUP_DIR:-./backups}"
mkdir -p "$OUT_DIR"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
pg_dump --format=custom --no-owner --no-privileges "$DATABASE_URL" > "$OUT_DIR/prodilive-$STAMP.dump"
find "$OUT_DIR" -type f -name 'prodilive-*.dump' -mtime +14 -delete
