## Overview
Converter NOW (`converterpro`) — Flutter unit and currency converter. Cross-platform (Android, Linux, Windows, Web). Monorepo managed as a Dart workspace. Open-source, no ads, daily currency updates.

## Project Structure
```
lib/
  main.dart            # ProviderScope, DynamicColorBuilder, MaterialApp.router
  app_router.dart      # Central GoRouter definition (routerProvider)
  models/              # Riverpod providers
  pages/               # App pages (UI)
  data/                # Default units order, unit-translation maps, etc.
  helpers/
  styles/
  utils/
assets/
packages/
  calculator_widget/   # Calculator Notifier + UI (lib/calculator_widget.dart, calculator_model.dart)
  translations/        # l10n source, generates AppLocalizations via flutter gen-l10n
tools/
  generate_exchange_rates.dart  # Fetches ECB rates -> default_exchange_rates.g.dart
integration_test/
  small_display_test.dart
  large_display_test.dart
  utils.dart
android/ linux/ windows/ web/  # Platform shells
```

Workspace declared in `pubspec.yaml` (`packages/calculator_widget`, `packages/translations`).

## Main Libraries

### Project Management — `melos`
- Config inline in `pubspec.yaml` (`melos:` block). No standalone `melos.yaml`.
- `melos bootstrap` required after clone (post-hook runs `generate_translations` + `compile_icons` + `generate_exchange_rates`).
- Scripts: `melos run analyze` (`flutter analyze` in all packages), `melos run compile_icons` (`vector_graphics_compiler`), `melos run generate_translations` (`flutter gen-l10n` in `packages/translations`), `melos run generate_exchange_rates`.

Other notable deps: `units_converter`, `shared_preferences`, `dynamic_color`, `intl` + `flutter_localizations`, `vector_graphics`/`flutter_svg`, `http`, `package_info_plus`.

### State Management — `flutter_riverpod`
- Root `ProviderScope` in `lib/main.dart`.
- Pattern: `AsyncNotifier`/`Notifier`/`StateProvider`/`Provider`
- `SettingsNotifier<T> extends AsyncNotifier<T?>` persists via `shared_preferences` (`sharedPref` FutureProvider).
- Examples: `significantFiguresProvider`, `themeModeProvider`, `actualColorThemeProvider`, `ConversionsNotifier`.

### Navigation — `go_router`
- Single `routerProvider` (`Provider<GoRouter>`) in `lib/app_router.dart`.
- Routes: `/` (SplashScreen), `/conversions` (InitialPage), `ShellRoute` -> `AppScaffold` wrapping `/conversions/:property` (+ `reorder`/`hide` sub-routes), `/settings` (+ `reorder-properties`/`about`). Property param uses kebab-case conversion (`lib/utils/utils.dart` `kebabStringToPropertyX`).
- Redirect logic gated by `isEverythingLoadedProvider` (waits for all AsyncNotifiers).

## Workflow

Prerequisite (once):
```bash
dart pub global activate melos
melos bootstrap
```

Do not edit generated outputs: `assets/*_opti/`, `lib/models/default_exchange_rates.g.dart`, generated `packages/translations` l10n files.

Lint rules from `analysis_options.yaml` (`package:flutter_lints/flutter.yaml`).

## Integration Tests

Located in `integration_test/` with shared helpers in `utils.dart` (clearPreferences, dragGesture, setWindowSize).

- `small_display_test.dart` — simulates phone window `400x800`
- `large_display_test.dart` — simulates desktop window `800x700`

Both cover conversions, clear/undo, language switching, reordering units/properties.

Run (requires `melos bootstrap` first):

```bash
flutter test integration_test/small_display_test.dart -d linux
flutter test integration_test/large_display_test.dart -d linux
```

## Commit Policy

**Never commit.** Do not run `git commit`, `git commit --amend`, `git push`, or any `gh` publish flow. Leave all changes unstaged/uncommitted for the user to review.
