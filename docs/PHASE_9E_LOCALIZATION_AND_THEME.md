# Phase 9E Localization And Theme

## Implementation Summary

Phase 9E adds:

- A new `Settings` page at `/settings`
- App-level locale preference: Vietnamese (`vi`) or English (`en`)
- App-level theme preference: Light, Dark, or System
- Local persistence through `shared_preferences`
- Immediate application of locale/theme changes across the app
- Dark theme support for the main reusable surfaces used by Dashboard,
  Transactions, Statistics, Reports, and Settings

## Why Option A+ Was Chosen

- Lower risk than full ARB/gen-l10n setup in this polish phase
- Fast enough to ship before Android toolchain work
- Still structured to avoid string sprawl and painful future migration

## Files And Roles

- `AppLocale`: locale enum and supported locale list
- `AppStringKey`: typed string key registry
- `AppStrings`: translation store + helper formatting methods + delegate
- `AppPreferencesController`: app-level Riverpod controller for locale/theme
- `SharedPreferencesAppPreferencesRepository`: persistent storage adapter

## How To Add A New String

1. Add a new key to `AppStringKey`
2. Add translations for both `AppLocale.vi` and `AppLocale.en` in `AppStrings`
3. Use the key in UI with `context.strings.t(...)`
4. If the string needs placeholders, prefer adding a helper method on
   `AppStrings` instead of building locale-sensitive grammar in widgets

## How To Add A New Language

1. Add a new case to `AppLocale`
2. Add its `Locale(...)` to `supportedLocales`
3. Add a translation map in `AppStrings._values`
4. Expose the language in the Settings page
5. Add focused tests for a few representative labels

## Future Migration To Flutter ARB/Gen-L10n

1. Create `lib/l10n/app_en.arb` and `lib/l10n/app_vi.arb`
2. Reuse the current `AppStringKey` names as ARB keys where practical
3. Enable Flutter localization code generation
4. Replace `AppStrings` lookups with generated `AppLocalizations`
5. Keep `AppPreferencesController` as the source of the selected `Locale`

