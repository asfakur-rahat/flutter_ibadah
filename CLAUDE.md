# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`flutter_ibadah` is a published pub.dev **package** (not an app): a self-contained widget that shows Islamic prayer times for any city worldwide (it was Bangladesh-only before 0.3.0). The root is the package; `example/` is a runnable demo app that depends on it via `path: ../`.

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

**`.pubignore` replaces `.gitignore` for `pub publish`, it does not add to it.** Every exclusion the package relies on (`build/`, `.dart_tool/`, `.fvm/`, ...) must be restated there. Getting this wrong shipped a 32 MB tarball in 0.2.1; `pub publish --dry-run` should report ~1 MB.

## Architecture

Clean-architecture layering under `lib/src/`, with a single public surface exported from `lib/flutter_ibadah.dart`: `IbadahWidget`, `IbadahTheme`, `IbadahStrings`, `IbadahController`, `IbadahLocation`, `IbadahCalculationMethod`, `IbadahSchool`, `bangladeshDistricts`. Everything else is private to the package — adding a new public type means adding an export there.

Data flow for a prayer-time fetch:

```
IbadahWidget → IbadahBloc(FetchSalatTime{location, method, school}) → IbadahUseCase
  → IbadahRepositoryImpl → IbadahService → DioService.callApiService → aladhan.com API
  → SalatTimeTableModel.fromJson → .toEntity() → SalatTimeTableEntity
  → SalatTimeFetchSuccess → BlocListener → ValueNotifier<SalatTimeTableEntity>
```

Things that are easy to get wrong:

- **Bloc is used only for fetching, not for rendering.** `IbadahWidget` owns its own `IbadahBloc` instance and a `BlocProvider`, but a hidden `BlocListener` at the bottom of the tree pushes state into `ValueNotifier`s (`salatTimeEntity`, `currentPrayer`, `periodicRefresh`, `selectedLocation`), and the visible tree rebuilds from those. Don't convert this to `BlocBuilder` piecemeal — the notifiers are what the sub-widgets listen to.
- **Two independent timers.** `IbadahWidget` flips `periodicRefresh` every 30 minutes (re-evaluates past/upcoming styling); `NextPrayerWidget` ticks every second for the countdown and reports the next prayer name upward via `getNextPrayerName`.
- **Current-prayer highlight is matched by localized string.** `SalahTimeWidget._isCurrentPrayer()` compares `title == currentPrayer`, and both come from `CommonUtils.getIbadahString(...)`. Changing how prayer names are produced in one place silently breaks the highlight.
- **`DioService`, `HiveService`, `IbadahLinks` are singletons.** `HiveService` requires `Hive.initFlutter()` + `init()` before use; `IbadahWidget._initHive()` does this itself so host apps need no setup. Only `kIbadahLocationKey` (`"ibadah_location_v1"`) is cached, holding a JSON-encoded `IbadahLocation`. `IbadahWidget._restoreCachedLocation()` migrates the pre-0.3.0 `"district"` key (a bare city name) and deletes it.
- **Times are rendered in the selected city's timezone, never the device's.** `DateTime.parse` throws the offset away, so `SalatTimeTableModel.parseUtcOffset` reads it off the raw ISO8601 string and it rides along on `SalatTimeTableEntity.utcOffset`. Display goes through `CommonUtils.inZone`/`formatTimeDefault(utcOffset:)`; the midnight refetch and `_isToday` use the city's calendar day. Do **not** reintroduce `.toLocal()`. The countdown in `NextPrayerWidget` compares absolute instants and is correct as-is.
- **`DioService.get` does a DNS lookup to google.com** before every request and throws a `DioException` when offline — this makes networked code untestable without mocking; existing tests avoid the network path.

## Localization and theming contract

`IbadahWidget` asserts that `supportedLocals` and `ibadahStrings` are the same length and that `currentLocale` is in `supportedLocals`. Lookup is positional: `ibadahStrings[supportedLocals.indexOf(currentLocale)]`, so the two lists must stay index-aligned. There is no ARB/intl-generated localization — `IbadahStrings` is a plain const class with defaults in `ibadah_defaults.dart`.

Digits are localized separately by `CommonUtils.formatNumber` using the `numberMap` (en/bn/ar/fa/ur); adding a locale with non-Latin digits means extending that map too. Unknown locales fall back to Latin digits rather than throwing, and `CommonUtils.getIbadahString` falls back to index 0 rather than a `RangeError` (the widget's assert is debug-only).

`IbadahTheme` has `light()`, `dark()`, and `fromSeed()` (a hand-rolled `_tone()` lightness ramp, not Material's `ColorScheme.fromSeed`). New theme fields must be added to all three constructors and documented in the README's theme table.

## Assets

Gallery screenshots live in `doc/screenshots/` (downscaled, listed under `screenshots:` in `pubspec.yaml`) and `doc/screenshots/raw/` (full-res, `.pubignore`d, linked from the README by absolute raw.githubusercontent.com URLs).

SVG icons in `assets/icons/` are loaded with `package: 'flutter_ibadah'` and recolored at runtime by `SvgColorMapper` (`flutter_svg` `ColorMapper`) rather than via `colorFilter` — new icons should be single-color so remapping works. The Satoshi font family is bundled in `pubspec.yaml`. The default location list is `const List<IbadahLocation> bangladeshDistricts` in `lib/src/presentation/core/bangladesh_districts.dart`; hosts override it with `IbadahWidget.locations`. `kDefaultIbadahLocation` (Dhaka) keeps the historical opening city even though the list is alphabetical.

## API detail

Endpoint is `https://api.aladhan.com/v1/timingsByAddress/<dd-MM-yyyy>?address=<city>,<country>&iso8601=true&method=<id>&school=<id>`, built with `Uri` so spaces and apostrophes are escaped. It works for any city worldwide. `method` and `school` default to 1 (Karachi) and 1 (Hanafi) — the South Asian convention — and are overridable per widget. An address the geocoder cannot resolve returns a 400 whose body is a bare string, surfaced as `IbadahStrings.locationNotFound`. `isFriday` is derived from `data.date.gregorian.weekday.en`, and drives the Dhuhr→Jum'ah label and icon swap.