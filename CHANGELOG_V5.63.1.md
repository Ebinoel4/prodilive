# v5.63.1

- Corrected ambiguous PostgreSQL arithmetic when calculating reviewer deadlines for cancellation and dispute requests.
- Raised mobile navigation above floating chat overlays and moved the Tawk launcher above the mobile tabs.
- Restored live chat for all signed-in roles; the built-in support bubble remains visible if Tawk cannot load.

Deploy this package and check both actions on a test project. If either still returns 500, inspect Render logs for the exact PostgreSQL error and verify pending migrations completed.
