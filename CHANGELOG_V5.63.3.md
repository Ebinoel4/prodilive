# v5.63.3 — fix buttons blocked by CSP

- Helmet's default CSP adds `script-src-attr 'none'`, which blocks every inline `onclick`/`onchange` handler. On mobile (and desktop) no button worked. Added `scriptSrcAttr: ['unsafe-inline']` so the existing handlers run again.
- No other changes. Longer term: migrate inline handlers to addEventListener so this can be tightened.
