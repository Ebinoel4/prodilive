# v5.13.0 — Payout details: Bank name, Account name, Account number

## What changed
The provider payout form (Dashboard → Identity verification's neighbor
section, "Payout details") now asks for:
- **Bank name** — a dropdown of major Nigerian banks (GTBank, Access,
  Zenith, UBA, Kuda, Opay, Palmpay, etc.), plus an "Other" option with a
  manual code field for anything not listed
- **Account name** — the name on the account
- **Account number** — unchanged, still 10 digits

Under the hood, Paystack's transfer system still needs the numeric bank
code (e.g. GTBank = 058) to move money — the dropdown handles that mapping
for the user so they never have to know or type a code themselves.

The saved account name is now also used as the payee name when creating
the Paystack transfer recipient (previously it always used the person's
registered platform name, which may not match their bank account name and
could cause transfer mismatches).

New migration: `migrations/010_payout_account_name.sql`.

## Note
This lives under the **provider (talent)** dashboard, since providers are
who receive payouts — clients pay, they don't get paid out. If you meant
something different by "clients," let me know and I'll adjust.

## Deploy steps
Just push — the new migration auto-applies on the next restart (see
v5.11.0's self-migration change), no manual step needed.
