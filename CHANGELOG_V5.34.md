# PRODILIVE v5.34
- Unified normal users into one `member` account: members can both post jobs and find/accept work.
- Existing client/talent accounts migrate automatically to member.
- Reviewer and admin remain elevated roles.
- Admin can claim/review disputes.
- Reviewer decisions up to the configured auto-resolution limit can resolve without admin bottleneck.
- Default reviewer auto-resolution limit: 100,000 (configurable in settings).
- Split settlements, above-limit cases, and explicitly escalated cases go to ADMIN_REVIEW before funds move.
- Admin receives notification for escalated cases and has finalization endpoint.
- Full audit events are retained for reviewer recommendations and admin final decisions.
