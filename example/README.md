# Flutter Ibadah Example

This example demonstrates how to use the `flutter_ibadah` package in your Flutter application.

## What this example shows

The demo is split into four tabs, and the app bar toggles theme (light/dark)
and locale (English / বাংলা / العربية) across all of them.

- **Global** — one `IbadahWidget` over nine cities in nine countries, with a
  live read-out of every `IbadahController` getter and pull-to-refresh wired to
  `controller.refresh()`. Pick Toronto while your machine is on Dhaka time and
  the times stay Toronto's.
- **Bangladesh** — an `IbadahWidget` with *no* `locations`, `calculationMethod`
  or `school`, proving the defaults still give the 64 districts, Karachi/Hanafi
  and Dhaka. Plus a short list using `IbadahLocation.label` for Bangla names.
- **Calculation** — dropdowns bound to `calculationMethod` and `school`, so you
  can watch the times move between Karachi, ISNA, Umm al-Qura and the rest.
- **Theming** — `IbadahTheme.fromSeed()` and a fully custom theme with a
  gradient background.

## Features Demonstrated

- Prayer times for any city in any country
- Times rendered in the selected city's timezone, not the device's
- Real-time countdown to the next prayer
- Searchable location selection
- All 24 calculation methods and both Asr schools
- Theme switching (light/dark) and three theming approaches
- Language switching, including Arabic-Indic digits

## Running the Example

1. Navigate to the example directory:
   ```bash
   cd example
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Usage Examples

### Basic Light Theme
```dart
IbadahWidget(
  currentLocale: 'en',
  supportedLocals: const ['en', 'bn'],
  ibadahTheme: IbadahTheme.light(),
  ibadahStrings: const [IbadahStrings()],
)
```

### Worldwide locations
```dart
IbadahWidget(
  currentLocale: 'en',
  ibadahTheme: IbadahTheme.light(),
  locations: const [
    IbadahLocation(city: 'Mecca', country: 'Saudi Arabia'),
    IbadahLocation(city: 'Toronto', country: 'Canada'),
  ],
  calculationMethod: IbadahCalculationMethod.ummAlQura,
  school: IbadahSchool.shafi,
)
```

### Theme from Seed Color
```dart
IbadahWidget(
  currentLocale: 'en',
  supportedLocals: const ['en'],
  ibadahTheme: IbadahTheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.light,
  ),
  ibadahStrings: const [IbadahStrings()],
)
```

### Custom Theme
```dart
IbadahWidget(
  currentLocale: 'en',
  supportedLocals: const ['en'],
  ibadahTheme: const IbadahTheme(
    backgroundColor: Color(0xFFF5F5F5),
    primaryColor: Color(0xFF6200EE),
    secondaryColor: Color(0xFF03DAC6),
    foregroundOnBackground: Color(0xFF000000),
    foregroundOnPrimary: Color(0xFFFFFFFF),
    foregroundOnSecondary: Color(0xFF000000),
    border: Color(0xFFE0E0E0),
  ),
  ibadahStrings: const [IbadahStrings()],
)
```

## Supported Platforms

- ✅ Android
- ✅ iOS  
- ✅ Windows
- ✅ macOS
- ✅ Linux
