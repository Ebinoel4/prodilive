# v5.63.4 — same-origin requests always allowed

- The CORS check rejected any request whose Origin differed from APP_URL/CORS_ORIGINS, returning a 500 for every POST/PUT fetch. When testing on a different address (e.g. *.up.railway.app while APP_URL is www.prodilive.com) all action buttons failed. Requests from the site's own host are now always allowed.
- Includes v5.63.3 (CSP script-src-attr fix).
