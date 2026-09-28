-- Reviewer escalation and high-value/split recommendations require this status.
ALTER TABLE disputes DROP CONSTRAINT IF EXISTS disputes_status_check;
ALTER TABLE disputes ADD CONSTRAINT disputes_status_check CHECK (status IN ('OPEN','ASSIGNED','ADMIN_REVIEW','DECIDED'));
