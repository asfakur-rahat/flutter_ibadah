## 0.3.1

- Fix: opening the location picker tripped a framework assertion on Flutter
  3.44 — *"ListTile background color or ink splashes may be invisible"*. The
  sheet's rows were wrapped in a `ColoredBox`, which sits between them and the
  nearest `Material`, so their ink splashes painted behind an opaque box. It is
  now a `Material` of the same colour, which both paints the background and
  gives the rows something to ripple on. Debug-only assertion, but the missing
  tap feedback was real in release builds too
- Fix: selecting a location threw a `LateError` when the on-device cache was
  unavailable — `HiveService` used a `late` box that was only assigned on a
  successful `init()`. The cache is a convenience, so every accessor now
  tolerates a box that was never opened (an unwritable documents directory, a
  corrupt file, a host that never initialises Hive) and prayer times still load
- Add widget tests that actually open the picker. Nothing in the suite reached
  it before, which is how both bugs above shipped in 0.3.0

## 0.3.0

Prayer times for any city in the world, not just Bangladesh. **No breaking
changes** — every existing `IbadahWidget(...)` keeps compiling and behaving
identically, because the new parameters default to the old behaviour.

### Added

- `IbadahWidget.locations` — the places a user can pick between, as
  `List<IbadahLocation>`. Defaults to `bangladeshDistricts` (the same 64
  districts as before), so omitting it changes nothing
- `IbadahLocation(city:, country:, label:)`, a new public type. `label` lets the
  displayed name differ from what is sent to the API
- `IbadahWidget.initialLocation` — the location shown on first run. Defaults to
  Dhaka when it is in `locations`, otherwise the first entry
- `IbadahWidget.calculationMethod` and `IbadahWidget.school`, exposing all 24
  calculation methods (`IbadahCalculationMethod`) and both Asr schools
  (`IbadahSchool`). Default to Karachi/Hanafi, which is what the package sent
  before
- `IbadahController.location` (an `IbadahLocation?`), and a new
  `IbadahStrings.locationNotFound` string
- Arabic, Persian and Urdu digits in the number map, alongside English and Bangla

### Fixed

- **Prayer times now render in the selected city's timezone, not the device's.**
  Previously every time was `toLocal()`-ed, which was invisible while all 64
  districts shared UTC+6 but wrong as soon as a city in another zone was picked.
  The city's UTC offset is now read off the ISO8601 response and carried on
  `SalatTimeTableEntity.utcOffset`. The midnight refetch and the past/upcoming
  styling follow the city's calendar day too. The countdown was already correct,
  as it compares absolute instants
- The request URL is built with `Uri` instead of string interpolation, so cities
  and countries containing spaces or apostrophes — "Cox's Bazar", "Saudi Arabia"
  — are escaped rather than sent raw
- An address the API cannot geocode comes back as a 400 whose body is a bare
  string; this used to surface as "Unknown Error Occurred" and now shows
  `IbadahStrings.locationNotFound`
- The cached location is dropped when it is not in the host's `locations` list,
  instead of leaving an unreachable city selected
- **The published archive was 32 MB instead of ~1 MB.** The root `.pubignore`
  added in 0.2.1 *replaces* `.gitignore` for `pub publish` rather than adding to
  it, so `build/` and `.dart_tool/` — including two ~50 MB `.dill` caches — were
  shipped to every consumer. `.pubignore` now restates those exclusions, and
  `CLAUDE.md` and `flutter_ibadah.iml` are no longer published either
- `CommonUtils.getIbadahString` threw a `RangeError` in release builds when
  `currentLocale` was not in `supportedLocals` (the guarding assert is stripped
  outside debug); it now falls back to the first `IbadahStrings` entry

### Changed

- `IbadahStrings.searchHintText` now defaults to `'Search location'`
  (was `'Search district'`). The field name is unchanged
- `IbadahController.district` is deprecated in favour of `location`; it still
  works and returns the city name. It will be removed in 1.0.0
- The location picker shows the country as a subtitle when the list spans more
  than one
- Raise `flutter_lints` to ^6.0.0 and widen `equatable` to `>=2.0.7 <4.0.0`
  (resolves equatable 3.0.0, flutter_svg 2.3.0)
- Drop the unused `flutter: generate: true` flag — the package has no `l10n.yaml`
  or ARB files; localization is the hand-rolled `IbadahStrings`
- Example app: Gradle 8.12 → 8.14, AGP 8.7.3 → 8.11.1, Kotlin 2.1.0 → 2.2.20 and
  Java 11 → 17, clearing the "support will soon be dropped" warnings on
  Flutter 3.44

### Migration

Nothing is required. To go global, pass `locations` (and usually
`calculationMethod`) — see the README. Any existing cached district is migrated
to `IbadahLocation(city: <district>, country: 'Bangladesh')` automatically.

## 0.2.1

- Widen the `flutter_bloc` constraint to `>=8.1.6 <10.0.0` so the package
  supports flutter_bloc 9.x (verified against 9.1.1 and the 8.1.6 lower bound)
- Drop the `meta` dependency and the `@internal` annotations on
  `IbadahController.attach`/`detach`/`sync`; they are now plain public members
  documented as called by `IbadahWidget`, mirroring `ScrollController.attach`

## 0.2.0

- Add `IbadahController` so host apps can trigger a refresh on demand (`controller.refresh()`) and observe the fetch state (`status`, `district`, `lastUpdated`, `errorMessage`); pass it via the new `IbadahWidget.controller` parameter
- Fix: a failed prayer-time fetch is no longer permanent. The widget now retries automatically on a 15s/30s/1m/2m/5m backoff, so it recovers on its own once connectivity returns instead of staying empty until the app restarts or the district changes
- Fix: the timetable now refetches just after midnight, so a long-running app no longer keeps showing the previous day's times
- Show the failure instead of swallowing it: a retry button appears when a fetch fails, and a spinner while one is in flight. Previously fetched times stay visible during a failure
- `SalatTimeFetchFailed` now carries the failure message; overlapping fetches are dropped rather than raced
- Add the `retry` string to `IbadahStrings` (defaults to `'Retry'`)
- Fix `IbadahWidget.dispose` calling `super.dispose()` first and leaking two `ValueNotifier`s

## 0.1.1

- Updated `NextPrayerWidget` to use `currentPrayerColor` from the theme instead of a hardcoded grey color.

## 0.1.0

- Replaced hardcoded border color in IbadahWidget with widget

## 0.0.9

- Add `IbadahTheme.backgroundGradient` and the `IbadahWidget.useGradient` flag for gradient backgrounds
- Add `IbadahTheme.salatIconBackground` to customize the circular badge behind each prayer icon
- Fix the widget container using `foregroundOnPrimary` instead of `backgroundColor` as its background

## 0.0.8

- Fix a issue where current prayer time wasn't highlighted correctly
- Add proper runnable example app

## 0.0.7

- Minor bug fixes

## 0.0.6

- Minor bug fixes

## 0.0.5

- Updated dependencies to latest stable versions (flutter_bloc 9.1.1, intl 0.20.2)
- Fixed all static analysis issues and lint warnings
- Applied consistent Dart formatting across entire codebase
- Added comprehensive documentation for missing public API elements
- Enhanced example app with better demonstrations
- Improved pub.dev scoring for static analysis (150/200 score)
- Fixed type annotation issues in utility methods
- All code now passes flutter analyze with zero issues


## 0.0.4

- Fixed all remaining static analysis issues (11 → 0 issues)
- Added missing type annotations for better code quality
- Fixed dead null-aware expression warnings
- Applied consistent code formatting across entire codebase
- Improved pub.dev scoring for static analysis (40/50 → 50/50 expected)

## 0.0.3

- Fixed README version mismatch (corrected from 1.0.0 to 0.0.3)
- Added comprehensive documentation for all public API elements
- Fixed static analysis issues (missing type annotations)
- Updated dependencies to latest versions (flutter_bloc 9.1.1, dio 5.9.0, intl 0.20.2, flutter_svg 2.2.1)
- Added complete example app demonstrating all package features
- Enhanced library documentation with proper dartdoc comments
- Improved pub.dev scoring compliance
- Fixed all lint and formatting issues

## 0.0.2

- Added multi-language support.
- Improved theming options with light and dark modes.
- Added district/location selection feature.
- Enhanced responsive design for various screen sizes.
- Fixed minor bugs and improved performance.

## 0.0.1

- Initial release with basic prayer time display.