# PRODILIVE architecture

Browser → HTTPS reverse proxy → Express API → PostgreSQL
                                      ├→ Paystack
                                      ├→ SMTP
                                      └→ protected file storage + FFmpeg

Core lifecycle:
OPEN → AWAITING_PAYMENT → IN_PROGRESS → QA_PENDING → CLIENT_REVIEW → APPROVED → RELEASE_PENDING → RELEASED
                                                        ↘ REVISION_REQUESTED ↗
Any active stage can enter DISPUTED; reviewer/admin resolves to a release decision.
