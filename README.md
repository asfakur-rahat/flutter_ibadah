# Flutter Ibadah

[![Pub Version](https://img.shields.io/pub/v/flutter_ibadah?style=for-the-badge)](https://pub.dev/packages/flutter_ibadah)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A beautiful, customizable Flutter widget for displaying Islamic prayer times with support for multiple languages and locations. Works for **any city in any country**, and can be easily integrated into any Flutter application.

| Dhaka, Bangladesh | Toronto, Canada | Mecca, dark theme | Cairo, in Arabic |
|:---:|:---:|:---:|:---:|
| <img src="https://raw.githubusercontent.com/asfakur-rahat/flutter_ibadah/main/doc/screenshots/raw/01_dhaka.png" width="200" alt="Prayer times for Dhaka with the next-prayer countdown"> | <img src="https://raw.githubusercontent.com/asfakur-rahat/flutter_ibadah/main/doc/screenshots/raw/02_toronto.png" width="200" alt="Toronto prayer times, rendered in Toronto time"> | <img src="https://raw.githubusercontent.com/asfakur-rahat/flutter_ibadah/main/doc/screenshots/raw/03_mecca_dark.png" width="200" alt="Mecca prayer times on the dark theme"> | <img src="https://raw.githubusercontent.com/asfakur-rahat/flutter_ibadah/main/doc/screenshots/raw/04_cairo_arabic.png" width="200" alt="Cairo prayer times with Arabic strings and digits"> |

*All four are the same widget on the same device — only `locations`,
`calculationMethod`, `currentLocale` and `ibadahTheme` differ.*

## Features ✨

- 🕌 Displays all five daily prayer times
- ⏳ Shows next prayer with countdown
- 🌍 Worldwide: any city, any country — supply your own location list
- 🕰️ Times render in the **selected city's** timezone, not the device's
- 🧭 24 calculation methods and both Asr schools
- 🌐 Multi-language support, including localized digits (en, bn, ar, fa, ur)
- 🎨 Customizable theming with seed color support
- 📍 Searchable location selection
- 📱 Responsive design
- 🌓 Built-in light and dark themes
- 🔄 Automatic recovery: retries a failed fetch with backoff and refetches at midnight
- 🎛️ `IbadahController` for manual refresh (pull-to-refresh, app resume, your own connectivity listener)

## Installation 💻

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_ibadah: ^latest_version
```

Then run:
```bash
flutter pub get
```

## Basic Usage 🚀

### Using IbadahWidget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_ibadah/flutter_ibadah.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: IbadahWidget(
            currentLocale: 'en',
            supportedLocals: const ['en', 'bn'],
            ibadahTheme: IbadahTheme.light(),
            ibadahStrings: const [IbadahStrings()],
          ),
        ),
      ),
    );
  }
}
```

### Choosing locations 🌍

With no `locations`, the widget offers the 64 districts of Bangladesh and opens
on Dhaka — the behaviour it has always had. Pass your own list to show anywhere
in the world:

```dart
IbadahWidget(
  currentLocale: 'en',
  ibadahTheme: IbadahTheme.light(),
  locations: const [
    IbadahLocation(city: 'Mecca', country: 'Saudi Arabia'),
    IbadahLocation(city: 'Istanbul', country: 'Turkey'),
    IbadahLocation(city: 'Toronto', country: 'Canada'),
    IbadahLocation(city: 'Jakarta', country: 'Indonesia'),
  ],
  initialLocation: const IbadahLocation(city: 'Mecca', country: 'Saudi Arabia'),
  calculationMethod: IbadahCalculationMethod.ummAlQura,
  school: IbadahSchool.shafi,
)
```

`city` and `country` are sent to the prayer-time API as a `"<city>,<country>"`
address, so spell them the way a geocoder expects — English names work best.
Use `label` when the text shown to the user should differ from what is sent:

```dart
const IbadahLocation(city: 'Dhaka', country: 'Bangladesh', label: 'ঢাকা')
```

The default list is exported as `bangladeshDistricts`, so you can extend rather
than replace it:

```dart
locations: const [
  ...bangladeshDistricts,
  IbadahLocation(city: 'Mecca', country: 'Saudi Arabia'),
],
```

### Calculation method and school 🧭

Fajr and Isha depend on whose solar angles you follow, and Asr on the juristic
school. Both default to the South Asian convention
(`IbadahCalculationMethod.karachi` and `IbadahSchool.hanafi`), so existing code
is unaffected. Set them to match your users' local mosques:

| Region | Typical setting |
|--------|-----------------|
| Bangladesh, Pakistan, India | `karachi` + `hanafi` (the default) |
| Saudi Arabia | `ummAlQura` + `shafi` |
| North America | `isna` |
| Europe | `muslimWorldLeague` |
| Indonesia | `indonesia` |
| Turkey | `turkey` |

`IbadahCalculationMethod` covers all 24 methods the API supports.

### Timezones 🕰️

Prayer times are rendered in the **selected city's** timezone, not the device's.
Pick Toronto while your phone is on Dhaka time and you see Toronto's times, and
the day rolls over at Toronto's midnight. The countdown to the next prayer
compares absolute instants, so it is correct in every case.

### Using fromSeed Constructor

Create a theme from a seed color:

```dart
IbadahWidget(
  currentLocale: 'en',
  supportedLocals: const ['en'],
  ibadahTheme: IbadahTheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light, // or Brightness.dark
  ),
  ibadahStrings: const [IbadahStrings()],
)
```

## Customization 🎨

### Theming

Customize the appearance using `IbadahTheme`:

```dart
IbadahTheme(
  backgroundColor: Colors.white,      // Background color of the main container
  primaryColor: Colors.blue,         // Primary color for important UI elements
  secondaryColor: Colors.lightBlue,  // Secondary color for less prominent elements
  foregroundOnBackground: Colors.black87,  // Text color on background
  foregroundOnPrimary: Colors.white,       // Text color on primary color
  foregroundOnSecondary: Colors.white,     // Text color on secondary color
  border: Colors.grey[300]!,               // Border color for UI elements
)
```

## Theme Options

### Built-in Presets

#### Light Theme
```dart
IbadahTheme.light()
```

**Color Values:**
- `backgroundColor`: `Colors.white`
- `primaryColor`: `Colors.blue[700]!`
- `secondaryColor`: `Colors.blue[500]!`
- `foregroundOnBackground`: `Colors.black87`
- `foregroundOnPrimary`: `Colors.white`
- `foregroundOnSecondary`: `Colors.white`
- `border`: `Colors.grey[300]!`
- `currentPrayerColor`: `Colors.blue[700]!`
- `upcomingPrayerColor`: `Colors.blue[500]!`
- `previousPrayerColor`: `Colors.grey[300]!`

#### Dark Theme
```dart
IbadahTheme.dark()
```

**Color Values:**
- `backgroundColor`: `Color(0xFF121212)`
- `primaryColor`: `Colors.blue[200]!`
- `secondaryColor`: `Colors.blue[400]!`
- `foregroundOnBackground`: `Colors.white70`
- `foregroundOnPrimary`: `Colors.black87`
- `foregroundOnSecondary`: `Colors.black87`
- `border`: `Colors.grey[800]!`
- `currentPrayerColor`: `Colors.blue[200]!`
- `upcomingPrayerColor`: `Colors.blue[400]!`
- `previousPrayerColor`: `Colors.grey[800]!`

#### Custom Theme
Create your own theme with custom colors:

```dart
final customTheme = IbadahTheme(
  backgroundColor: const Color(0xFFF5F5F5),
  primaryColor: const Color(0xFF6200EE),
  secondaryColor: const Color(0xFF03DAC6),
  foregroundOnBackground: const Color(0xFF000000),
  foregroundOnPrimary: const Color(0xFFFFFFFF),
  foregroundOnSecondary: const Color(0xFF000000),
  border: const Color(0xFFE0E0E0),
);
```

### Theme Properties

| Property | Type | Description |
|----------|------|-------------|
| `backgroundColor` | Color | Background color of the main container |
| `primaryColor` | Color | Primary color for important UI elements |
| `secondaryColor` | Color | Secondary color for less prominent elements |
| `foregroundOnBackground` | Color | Text color on background |
| `foregroundOnPrimary` | Color | Text color on primary color |
| `foregroundOnSecondary` | Color | Text color on secondary color |
| `border` | Color | Border color for UI elements |
| `currentPrayerColor` | Color | Current prayer color |
| `upcomingPrayerColor` | Color | Upcoming prayer color |
| `backgroundGradient` | Gradient? | Gradient background, used only when `useGradient: true` |
| `salatIconBackground` | Color? | Fill of the circular badge behind each prayer icon |

### Gradient Background

Set a `backgroundGradient` on the theme and opt in with `useGradient`. When
`useGradient` is `false` (the default) the widget paints `backgroundColor` instead.

```dart
IbadahWidget(
  currentLocale: 'en',
  useGradient: true,
  ibadahTheme: const IbadahTheme(
    backgroundGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
    ),
    salatIconBackground: Colors.white,
    backgroundColor: Color(0xFFF8F8FF),
    primaryColor: Color(0xFF000000),
    secondaryColor: Color(0xFF43641A),
    foregroundOnBackground: Color(0xFF12111A),
    foregroundOnPrimary: Color(0xFFFFFFFF),
    foregroundOnSecondary: Color(0xFFFFFFFF),
    border: Color(0xFFE7E7E8),
    previousPrayerColor: Color(0xFFC4C4C4),
    currentPrayerColor: Color(0xFF000000),
    upcomingPrayerColor: Color(0xFF575660),
  ),
  ibadahStrings: const [IbadahStrings()],
)
```

Note: `backgroundGradient` and `salatIconBackground` are only available on the
default `IbadahTheme` constructor — the `light()`, `dark()`, and `fromSeed()`
presets leave both `null`.
| `previousPrayerColor` | Color | Previous prayer color |

### Localization

Easily add support for new languages:

```dart
IbadahStrings(
  ibadah: 'Ibadah',
  fajr: 'Fajr',
  dhuhr: 'Dhuhr',
  jummah: 'Jum'ah',
  asr: 'Asr',
  maghrib: 'Maghrib',
  isha: 'Isha',
  fajrNextDay: 'Fajr (next day)',
  somethingWentWrong: 'Something went wrong',
  upcoming: 'Upcoming',
  startIn: 'Start in',
  am: 'AM',
  pm: 'PM',
  searchHintText: 'Search location',
  retry: 'Retry',
  locationNotFound: 'Could not find that location',
)
```

## Refreshing 🔄

The widget fetches prayer times when it first mounts and whenever the user
picks a different location. On top of that it keeps itself current on its own:

- **Automatic retry.** If a fetch fails (typically no internet) the widget
  shows the error with a **Retry** button and retries in the background on a
  15s → 30s → 1m → 2m → 5m backoff, staying at five minutes thereafter. When
  connectivity comes back the times appear without any user action. Times that
  were already fetched stay on screen while this happens.
- **Date rollover.** A timer just past local midnight refetches the timetable
  for the new day, so a long-running app never shows yesterday's times.

### Manual refresh with `IbadahController`

Pass an `IbadahController` to refresh on demand and to observe the fetch state:

```dart
class _MyPageState extends State<MyPage> {
  final ibadahController = IbadahController();

  @override
  void dispose() {
    ibadahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ibadahController.refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          IbadahWidget(
            controller: ibadahController,
            ibadahTheme: IbadahTheme.light(),
            currentLocale: 'en',
          ),
        ],
      ),
    );
  }
}
```

`IbadahController` is a `ChangeNotifier`, so you can rebuild on its state:

```dart
ListenableBuilder(
  listenable: ibadahController,
  builder: (context, _) => Text('${ibadahController.status.name}'),
);
```

| Member | Type | Description |
|--------|------|-------------|
| `refresh()` | `Future<void>` | Refetches the current location. The future completes when the fetch settles (success or failure), so it is safe to `await` from a `RefreshIndicator`. No-op while detached. |
| `status` | `IbadahFetchStatus` | `initial`, `loading`, `success` or `failure` |
| `location` | `IbadahLocation?` | Location the widget last fetched for |
| `district` | `String?` | **Deprecated** — the city name only. Use `location`. |
| `lastUpdated` | `DateTime?` | Time of the last successful fetch; unchanged by a later failure |
| `errorMessage` | `String?` | Failure reason, or `null` when the last fetch did not fail |
| `isAttached` | `bool` | Whether a mounted `IbadahWidget` is using this controller |

Dispose the controller with your own `State`. A controller can drive only one
`IbadahWidget` at a time.

## API Reference

### IbadahWidget

The main widget that displays prayer times.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| currentLocale | String | Yes | Current locale code (e.g., 'en', 'bn') |
| supportedLocals | List<String> | Yes | List of supported locale codes |
| ibadahTheme | IbadahTheme | Yes | Theme configuration |
| ibadahStrings | List<IbadahStrings> | Yes | List of string translations |
| useGradient | bool | No | Paint `ibadahTheme.backgroundGradient` instead of `backgroundColor` (default `false`) |
| controller | IbadahController? | No | Handle for triggering a manual refresh and observing fetch state |
| locations | List\<IbadahLocation\> | No | Places the user can pick between (default: `bangladeshDistricts`) |
| initialLocation | IbadahLocation? | No | Location shown on first run; must be in `locations` (default: Dhaka if present, else the first entry) |
| calculationMethod | IbadahCalculationMethod | No | Prayer-time convention (default: `karachi`) |
| school | IbadahSchool | No | Juristic school for Asr (default: `hanafi`) |

### IbadahLocation

| Property | Type | Description |
|----------|------|-------------|
| city | String | City name as the geocoder should receive it |
| country | String | Country name as the geocoder should receive it |
| label | String? | Optional display text; does not affect the request |
| displayName | String | `label` when set, otherwise `city` |
| address | String | `"<city>,<country>"`, what the API receives |

### IbadahTheme.fromSeed()

Creates a theme from a seed color.

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| seedColor | Color | Yes | - | The base color to generate the theme from |
| brightness | Brightness | No | Brightness.light | The brightness of the theme (light/dark) |

### IbadahTheme

The main widget that displays prayer times.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| currentLocale | String | Yes | Current locale code (e.g., 'en', 'bn') |
| supportedLocals | List<String> | Yes | List of supported locale codes |
| ibadahTheme | IbadahTheme | Yes | Theme configuration |
| ibadahStrings | List<IbadahStrings> | Yes | List of string translations |

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support 💖

If you find this package useful, please consider giving it a ⭐️ on [GitHub](https://github.com/asfakur-rahat/flutter_ibadah).

## Example

For a complete example, check out the `example` directory.

## Roadmap

- ✅ Basic prayer times display
- ✅ Multi-language support
- ✅ Custom theming
- ✅ Worldwide locations with per-city timezones
- ✅ Configurable calculation method and school
- ⬜ Prayer notifications
- ⬜ Qibla direction
- ⬜ Hijri calendar integration
