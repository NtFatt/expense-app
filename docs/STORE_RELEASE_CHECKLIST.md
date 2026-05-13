# Store Release Checklist

## Build Metadata

- `applicationId` checked: no longer uses `com.example`
- App label checked: no longer uses default Flutter sample label
- Bump version in `pubspec.yaml` before any real store submission
- Rebuild release APK before packaging

## Visual Assets

- Existing platform icon files are present, but no new master launcher-icon asset/pipeline was added in this pass
- Final vetted launcher icon source asset is still needed before store packaging
- Feature graphic if needed
- Phone screenshots
- Tablet/desktop screenshots if relevant

## Listing Copy

- Short description
- Full description
- Privacy note:
  - data is stored locally on device/browser
  - no cloud account is required in current scope
- Known limitation note:
  - web storage is browser-local

## Functional Sign-Off

- `flutter analyze`
- `flutter test`
- `flutter build apk --release`
- Web persistence smoke
- Backup export/import smoke
- Transaction export smoke
- Pay Later export smoke
- Windows native backup import smoke is still pending sign-off
- Android backup import smoke requires a connected device/emulator

## Security / Compliance

- Production keystore not committed
- `key.properties` not committed
- No secrets in source control
- `.gitignore` blocks `/android/key.properties`, `*.jks`, and `*.keystore`
- Review permissions in Android manifest

## Not Yet Complete In Repo

- Final store-ready icon asset pipeline
- Production signing pipeline
- Listing screenshots/assets
- Store submission metadata package

