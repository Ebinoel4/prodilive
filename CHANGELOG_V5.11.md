# v5.11.0 — Migrations now run themselves. No more psql needed.

## The actual fix for "where do I run this?"
Every round so far has ended with "now run this migration file with psql" —
which kept being a dead end since you're on Render's free tier with no
Shell access. So instead of another workaround, this version removes the
step entirely:

**The app now applies any pending `migrations/*.sql` file automatically,
every time it starts up.** It tracks what's already been applied in a new
`schema_migrations` table, so each file only ever runs once, and it's safe
to redeploy repeatedly.

This means when you push this version and Render redeploys, it will
automatically run migrations 006, 007, 008, and 009 for you — the ones from
the last four rounds that you were never able to run by hand. You don't
need to touch `psql`, install anything, or find your `DATABASE_URL` at all.

## What to check after deploying
Render's **Logs** tab will show lines like:
```
Running migration: 006_admin_verification.sql
Migration applied: 006_admin_verification.sql
Running migration: 007_registration_fields.sql
...
```
If you see those, everything from the last several rounds is finally live:
admin delete/view-activity, ID verification (with selfie + doc type), and
the extended registration fields.

## Going forward
Any future database change I make will just be another file dropped into
`migrations/`, and it'll auto-apply the next time Render restarts your
service after you push. Nothing further to run, ever, on your end.

## One caveat
If a migration file ever has a genuine SQL error, the app logs it and stops
applying further migrations that boot — it won't skip a broken one and
plow ahead. That's intentional (better to stop and flag it than leave the
database half-migrated), but it means if you see a "Migration runner
failed" line in the logs, send me the exact error text and I'll fix the
file.
