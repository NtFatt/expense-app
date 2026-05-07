# Phase 9E Localization Notes

## Current Approach

Phase 9E uses the Option A+ lightweight localization approach:

- `lib/core/localization/app_locale.dart`
- `lib/core/localization/app_string_key.dart`
- `lib/core/localization/app_strings.dart`

This avoids Flutter code generation for now, but still keeps the structure close
to a future ARB/gen-l10n migration.

## Key Registry

- Supported locales: `vi`, `en`
- Stable message key registry: `AppStringKey`
- Typed translation access: `AppStrings`

UI labels should go through `AppStrings.of(context)` or the
`BuildContext.strings` extension rather than raw hardcoded text.

## Why This Is ARB/L10N-Ready

- Keys are centralized in `AppStringKey`
- Translations are grouped per locale in `AppStrings`
- `MaterialApp.router` is already wired with a localization delegate
- Future generated strings can reuse the same semantic key names

## Future Migration Path

1. Create `lib/l10n/app_en.arb`
2. Create `lib/l10n/app_vi.arb`
3. Move key names from `AppStringKey` into the ARB files
4. Enable Flutter `gen-l10n`
5. Replace `AppStrings.of(context)` usage with generated `AppLocalizations`
6. Keep the same key names where possible to avoid another UI-wide search
