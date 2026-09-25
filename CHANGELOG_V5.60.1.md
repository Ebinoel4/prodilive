# PRODILIVE v5.60.1

- Embedded the supplied Tawk.to widget directly into `public/index.html`.
- Render environment variables `TAWK_PROPERTY_ID` and `TAWK_WIDGET_ID` are no longer required for live chat.
- The legacy built-in support bubble remains as a fallback until Tawk.to reports that it has loaded, then it is hidden to avoid duplicate chat buttons.
- The Suggestions button remains separate and unchanged.
