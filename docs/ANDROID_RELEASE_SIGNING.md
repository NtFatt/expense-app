# Android Release Signing

## Current Repo State

- `applicationId`: `com.ntfatt.expenseapp`
- App label: `Expense App`
- `flutter build apk --debug` and `flutter build apk --release` are expected validation commands
- No production keystore is committed to this repository

## Security Guardrails

- `android/key.properties` must stay local
- `*.jks` and `*.keystore` are ignored by `.gitignore`
- Never commit passwords, aliases, or signing files

## Recommended Local Setup

1. Create a local keystore outside the repo or under `android/` on your machine only.
2. Create local `android/key.properties` with your real values.
3. Wire Gradle signing config to load that file only when present.
4. Keep CI/demo builds on unsigned or local-debug-safe flows unless a secure secret pipeline exists.

## Example `key.properties`

```properties
storePassword=your-store-password
keyPassword=your-key-password
keyAlias=expenseapp
storeFile=C:\\path\\to\\expenseapp-upload.jks
```

## Release Checklist

- Keystore exists locally
- `key.properties` exists locally and is not tracked
- `flutter build apk --release` succeeds
- App installs on device/emulator
- Version code/name are updated
- Final privacy/data note is ready for store metadata

## Scope Note

This repo is documentation-ready for release signing, but not production-signed by default.

