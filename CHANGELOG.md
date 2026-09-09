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