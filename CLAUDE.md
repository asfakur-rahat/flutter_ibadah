# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`flutter_ibadah` is a published pub.dev **package** (not an app): a self-contained widget that shows Bangladeshi salah times. The root is the package; `example/` is a runnable demo app that depends on it via `path: ../`.

## Commands

```bash
flutter pub get                       # root package deps
flutter analyze                       # lints (flutter_lints via analysis_options.yaml)
dart format .                         # required — pub.dev scores formatting
flutter test                          # all tests
flutter test test/common_utils_test.dart              # single file
flutter test --plain-name 'IbadahWidget builds'       # single test by name

cd example && flutter pub get && flutter run          # run the demo app
flutter pub publish --dry-run         # pre-release check (run from root)
```

Releasing: bump `version:` in `pubspec.yaml` **and** add a matching entry at the top of `CHANGELOG.md` — both are part of every release commit.

## Architecture

Clean-architecture layering under `lib/src/`, with a single public surface exported from `lib/flutter_ibadah.dart`: `IbadahWidget`, `IbadahTheme`, `IbadahStrings`. Everything else is private to the package — adding a new public type means adding an export there.

Data flow for a prayer-time fetch:

```
IbadahWidget → IbadahBloc(FetchSalatTime) → IbadahUseCase → IbadahRepositoryImpl
  → IbadahService → DioService.callApiService → aladhan.com API
  → SalatTimeTableModel.fromJson → .toEntity() → SalatTimeTableEntity
  → SalatTimeFetchSuccess → BlocListener → ValueNotifier<SalatTimeTableEntity>
```

Things that are easy to get wrong:

- **Bloc is used only for fetching, not for rendering.** `IbadahWidget` owns its own `IbadahBloc` instance and a `BlocProvider`, but a hidden `BlocListener` at the bottom of the tree pushes state into `ValueNotifier`s (`salatTimeEntity`, `currentPrayer`, `periodicRefresh`, `selectedDistrict`), and the visible tree rebuilds from those. Don't convert this to `BlocBuilder` piecemeal — the notifiers are what the sub-widgets listen to.
- **Two independent timers.** `IbadahWidget` flips `periodicRefresh` every 30 minutes (re-evaluates past/upcoming styling); `NextPrayerWidget` ticks every second for the countdown and reports the next prayer name upward via `getNextPrayerName`.
- **Current-prayer highlight is matched by localized string.** `SalahTimeWidget._isCurrentPrayer()` compares `title == currentPrayer`, and both come from `CommonUtils.getIbadahString(...)`. Changing how prayer names are produced in one place silently breaks the highlight.
- **`DioService`, `HiveService`, `IbadahLinks` are singletons.** `HiveService` requires `Hive.initFlutter()` + `init()` before use; `IbadahWidget._initHive()` does this itself so host apps need no setup. Only the `"district"` key is cached (last selected district).
- **`DioService.get` does a DNS lookup to google.com** before every request and throws a `DioException` when offline — this makes networked code untestable without mocking; existing tests avoid the network path.

## Localization and theming contract

`IbadahWidget` asserts that `supportedLocals` and `ibadahStrings` are the same length and that `currentLocale` is in `supportedLocals`. Lookup is positional: `ibadahStrings[supportedLocals.indexOf(currentLocale)]`, so the two lists must stay index-aligned. There is no ARB/intl-generated localization — `IbadahStrings` is a plain const class with defaults in `ibadah_defaults.dart`.

Digits are localized separately by `CommonUtils.formatNumber` using the `numberMap` (en/bn); adding a locale with non-Latin digits means extending that map too.

`IbadahTheme` has `light()`, `dark()`, and `fromSeed()` (a hand-rolled `_tone()` lightness ramp, not Material's `ColorScheme.fromSeed`). New theme fields must be added to all three constructors and documented in the README's theme table.

## Assets

SVG icons in `assets/icons/` are loaded with `package: 'flutter_ibadah'` and recolored at runtime by `SvgColorMapper` (`flutter_svg` `ColorMapper`) rather than via `colorFilter` — new icons should be single-color so remapping works. The Satoshi font family is bundled in `pubspec.yaml`. The district list is a hardcoded `const List<String> districts` at the bottom of `district_selection_bottom_sheet.dart`.

## API detail

Endpoint is `https://api.aladhan.com/v1/timingsByAddress/<dd-MM-yyyy>?address=<district>,Bangladesh&iso8601=true&method=1&school=1`. `method=1` (Karachi) and `school=1` (Hanafi) are deliberate for Bangladesh. `isFriday` is derived from `data.date.gregorian.weekday.en`, and drives the Dhuhr→Jum'ah label and icon swap.