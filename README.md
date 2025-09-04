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

You can customize the appearance using `IbadahTheme`:

```dart
IbadahTheme(
  backgroundColor: Colors.blue,
  primaryColor: Colors.blue,
  secondaryColor: Colors.blue,
  foregroundOnBackground: Colors.blue,
  foregroundOnPrimary: Colors.blue,
  foregroundOnSecondary: Colors.blue,
  border: Colors.blue,
)
```

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

### IbadahTheme

Customize the appearance of the prayer times widget.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| primaryColor | Color | Colors.blue | Primary theme color |
| backgroundColor | Color | Colors.white | Background color |
| textColor | Color | Colors.black87 | Default text color |
| accentColor | Color | Colors.blueAccent | Accent color for highlights |

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
