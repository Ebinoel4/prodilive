-- v5.63.0: mandatory minimum cancellation compensation once work has been
-- underway a while, and settings the auto-settle sweep reads.
INSERT INTO settings(key,value) VALUES('cancelMandatoryCompensationHours','48'::jsonb) ON CONFLICT (key) DO NOTHING;
INSERT INTO settings(key,value) VALUES('cancelMandatoryCompensationPercent','20'::jsonb) ON CONFLICT (key) DO NOTHING;
