# Storage Migration Plan

## Current Schemas

### Web Transactions Storage

- Key: `expense_app.web.transactions.v1`
- Current schema: `1`
- Payload:

```json
{
  "schemaVersion": 1,
  "transactions": []
}
```

Legacy compatibility:

- raw JSON list of transactions

### Web Pay Later Storage

- Key: `expense_app.web.pay_later.v1`
- Current schema: `1`
- Payload:

```json
{
  "schemaVersion": 1,
  "plans": [],
  "invoices": [],
  "payments": []
}
```

Legacy compatibility:

- unversioned JSON object with `plans`, `invoices`, `payments`

### Backup JSON

- Current schema: `1`
- Payload:

```json
{
  "schemaVersion": 1,
  "app": "expense_app",
  "exportedAt": "2026-05-08T13:02:01.440",
  "data": {
    "transactions": [],
    "payLater": {
      "plans": [],
      "invoices": [],
      "payments": []
    }
  }
}
```

## Current Hardening

- Unsupported future versions are rejected with `UnsupportedSchemaVersionException`.
- Backup decode also validates:
  - `app == expense_app`
  - required sections exist
  - duplicate IDs are rejected
  - payments must point to existing plans/invoices
- Corrupt browser-local payloads are preserved in dedicated `.corrupt.v1` keys before recovery.

## Recovery Behavior Today

### Transactions

- Corrupt payload is copied to `expense_app.web.transactions.corrupt.v1`
- Repository recovers to seeded sample transactions
- Repository rewrites a valid schema-v1 payload

### Pay Later

- Corrupt payload is copied to `expense_app.web.pay_later.corrupt.v1`
- Repository recovers to empty collections
- Repository rewrites a valid schema-v1 payload

## How To Add Schema V2

1. Add `currentSchemaVersion = 2` in the relevant codec.
2. Preserve decode support for schema `1`.
3. Add a conversion path from v1 -> v2 before model creation.
4. Reject unsupported future versions `> 2`.
5. Keep backup schema changes separate from per-feature local-storage schema changes unless both need to move together.
6. Add migration tests before enabling runtime writes to v2.

## Required Tests For Future Migration

- legacy unversioned payload still decodes when intended
- schema-v1 payload still decodes after v2 is introduced
- schema-v2 payload encodes and decodes symmetrically
- unsupported future version rejects with typed exception
- corrupt JSON recovery still preserves raw payload
- Vietnamese text survives migration
- Pay Later relation integrity still holds after migration
- backup import from v1 payload remains valid if backup schema is unchanged

## Browser Storage Risk

- Browser-local storage is still profile-local and can be removed by clearing site data.
- Backup/restore now mitigates portability risk, but it is not account sync.
- Any schema change should be followed by:
  - `flutter test`
  - `flutter run -d chrome --web-run-headless --no-resident`
  - manual web refresh/reopen smoke
  - manual backup export/import smoke

