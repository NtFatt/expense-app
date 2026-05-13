# App Icon Guide

## Current Status

- Android package name and label are production-safe for a CV/demo app.
- A finalized launcher icon pipeline is not included in this repo yet.

## Recommended Next Step

If you want store-ready polish:

1. Create a square source icon at high resolution.
2. Add a local icon-generation workflow such as `flutter_launcher_icons`.
3. Generate Android, Windows, and web icons from the same source asset.
4. Rebuild the app and verify the icon on every target.

## Guardrails

- Do not reference missing assets in config.
- Do not commit third-party logo assets without permission.
- Keep the current default/demo icon until final assets are ready.

