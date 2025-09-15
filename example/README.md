# Flutter Ibadah Example

This example demonstrates how to use the `flutter_ibadah` package in your Flutter application.

## What this example shows

- **Basic Usage**: Simple implementation with light and dark themes
- **Seed Color Theme**: Creating themes from a seed color with automatic color generation
- **Custom Theme**: Fully customized theme with specific colors
- **Multi-language Support**: Switching between English and Bengali
- **Responsive Design**: Works on different screen sizes

## Features Demonstrated

- Prayer time display for Bangladeshi locations
- Real-time countdown to next prayer
- District/location selection
- Theme switching (light/dark)
- Language switching (English/Bengali)
- Multiple theming approaches

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
