# Flutter Ibadah

[![Pub Version](https://img.shields.io/pub/v/flutter_ibadah?style=for-the-badge)](https://pub.dev/packages/flutter_ibadah)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A beautiful, customizable Flutter widget for displaying Islamic prayer times with support for multiple languages and locations.

## Features ✨

- 🕌 Displays all five daily prayer times
- ⏳ Shows next prayer with countdown
- 🌍 Multi-language support
- 🎨 Customizable theming
- 📍 District/location selection
- 📱 Responsive design

## Installation 💻

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_ibadah: ^1.0.0
```

Then run:
```bash
flutter pub get
```

## Basic Usage 🚀

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
        body: IbadahScreen(
          currentLocale: 'en',
          supportedLocals: const ['en', 'bn'],
          ibadahTheme: IbadahTheme.light(), // or IbadahTheme.dark()
          ibadahStrings: const [
            IbadahStrings(), // English
            IbadahStrings( // Bengali
              ibadah: 'ইবাদাত',
              fajr: 'ফজর',
              dhuhr: 'জোহর',
              asr: 'আসর',
              maghrib: 'মাগরিব',
              isha: 'ইশা',
              fajrNextDay: 'পরদিনের ফজর',
              somethingWentWrong: 'কিছু একটা সমস্যা হয়েছে',
              upcoming: 'আসন্ন',
              startIn: 'শুরু হবে',
              am: 'সকাল',
              pm: 'বিকাল',
              searchHintText: 'জেলা খুঁজুন',
            ),
          ],
        ),
      ),
    );
  }
}
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

### Light and Dark Theme Presets

For convenience, you can use the built-in theme presets:

```dart
///Theme Presets

///Light Theme
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

### Localization

Easily add support for new languages:

```dart
IbadahStrings(
  ibadah: 'Ibadah',
  fajr: 'Fajr',
  dhuhr: 'Dhuhr',
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

### IbadahScreen

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

- [x] Basic prayer times display
- [x] Multi-language support
- [x] Custom theming
- [ ] Prayer notifications
- [ ] Qibla direction
- [ ] Hijri calendar integration
