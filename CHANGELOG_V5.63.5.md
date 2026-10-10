# v5.63.5 — category photos and arrow icon on mobile

- The Content-Security-Policy `img-src` did not allow images.pexels.com, so the browser blocked the 8 "Explore creative talent" photos wherever the policy was applied (the broken images then showed their alt text, which is why each label appeared twice). Added https://images.pexels.com to img-src.
- iOS Safari draws "↗" as a blue emoji. Added the text-presentation selector (U+FE0E) so it renders as the plain arrow in the circle.
