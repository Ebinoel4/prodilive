# PRODILIVE v5.60.5

- Fixed Admin Audit Log so a legacy/missing audit schema cannot blank the Admin workspace.
- Audit endpoint now returns a safe error payload instead of crashing the view.
- Added migration 029 to normalize the audit table on older databases.
- Restored visibility of legacy reviewers that were accepted in older Reviewer flows but are not currently stored with role=reviewer.
- Legacy reviewers can be opened for work history, chatted with, suspended/reactivated, or deleted from Admin.
- Previously approved legacy applications without a linked account are shown separately and can receive a new private signup link.
