# Flutter Ibadah

[![Pub Version](https://img.shields.io/pub/v/flutter_ibadah?style=for-the-badge)](https://pub.dev/packages/flutter_ibadah)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A beautiful, customizable Flutter widget for displaying Islamic prayer times with support for multiple languages and locations. This widget provides a complete prayer time solution that can be easily integrated into any Flutter application.

## Features ✨

- 🕌 Displays all five daily prayer times
- ⏳ Shows next prayer with countdown
- 🌍 Multi-language support
- 🎨 Customizable theming with seed color support
- 📍 District/location selection
- 📱 Responsive design
- 🌓 Built-in light and dark themes

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
  searchHintText: 'Search district',
)
```

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
- ⬜ Prayer notifications
- ⬜ Qibla direction
- ⬜ Hijri calendar integration
