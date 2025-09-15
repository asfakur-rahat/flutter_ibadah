import 'package:flutter/cupertino.dart';

/// A theme configuration class for customizing the appearance of Ibadah widgets.
///
/// This class provides a comprehensive theming system that allows you to customize
/// colors, fonts, and other visual aspects of the prayer time display.
///
/// You can create themes using the factory constructors [IbadahTheme.light],
/// [IbadahTheme.dark], or [IbadahTheme.fromSeed] for automatic color generation.
class IbadahTheme {
  /// Creates a theme from a seed color, generating a harmonious color scheme
  factory IbadahTheme.fromSeed({
    required Color seedColor,
    Brightness brightness = Brightness.light,
  }) {
    final isDark = brightness == Brightness.dark;

    // Generate colors from seed
    final primary = isDark
        ? _tone(seedColor, 80) // Lighter in dark mode
        : _tone(seedColor, 40); // Darker in light mode

    final secondary = isDark ? _tone(seedColor, 60) : _tone(seedColor, 60);

    final background =
        isDark ? const Color(0xFF121212) : const Color(0xFFFFFFFF);

    final onBackground = isDark
        ? const Color(0xB3FFFFFF) // white70
        : const Color(0xDE000000); // black87

    final onPrimary = isDark
        ? const Color(0xFF000000) // black
        : const Color(0xFFFFFFFF); // white

    final onSecondary = isDark
        ? const Color(0xFF000000) // black
        : const Color(0xFFFFFFFF); // white

    final border = isDark
        ? const Color(0xFF424242) // grey[800]
        : const Color(0xFFE0E0E0); // grey[300]

    return IbadahTheme._(
      backgroundColor: background,
      primaryColor: primary,
      secondaryColor: secondary,
      foregroundOnBackground: onBackground,
      foregroundOnPrimary: onPrimary,
      foregroundOnSecondary: onSecondary,
      border: border,
    );
  }

  // Helper to generate a color tone from a seed
  /// Generates a color tone from a seed color.
  ///
  /// The tone is specified as a percentage, from 0 to 100.
  /// A tone of 0 generates a pure black color, while a tone of 100 generates
  /// a pure white color.
  ///
  /// This implementation is very simple, and you may want to use a more
  /// sophisticated color generation algorithm for production.
  ///
  /// See also: Flutter's ColorScheme.fromSeed method for advanced color generation.
  static Color _tone(Color seed, int tone) {
    // Simple implementation - you might want to use a more sophisticated
    // color generation algorithm for production
    final hsl = HSLColor.fromColor(seed);
    return hsl.withLightness(tone / 100).toColor();
  }

  /// Creates a light theme with default colors
  factory IbadahTheme.light() {
    return const IbadahTheme._(
      backgroundColor: Color(0xFFFFFFFF),
      primaryColor: Color(0xFF1976D2), // blue[700]
      secondaryColor: Color(0xFF2196F3), // blue[500]
      foregroundOnBackground: Color(0xDE000000), // black87
      foregroundOnPrimary: Color(0xFFFFFFFF), // white
      foregroundOnSecondary: Color(0xFFFFFFFF), // white
      border: Color(0xFFE0E0E0), // grey[300]
    );
  }

  /// Creates a dark theme with default colors
  factory IbadahTheme.dark() {
    return const IbadahTheme._(
      backgroundColor: Color(0xFF121212),
      primaryColor: Color(0xFF90CAF9), // blue[200]
      secondaryColor: Color(0xFF64B5F6), // blue[400]
      foregroundOnBackground: Color(0xB3FFFFFF), // white70
      foregroundOnPrimary: Color(0xDE000000), // black87
      foregroundOnSecondary: Color(0xDE000000), // black87
      border: Color(0xFF424242), // grey[800]
    );
  }

  /// Creates a custom theme with the given colors
  const IbadahTheme({
    required this.backgroundColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.foregroundOnBackground,
    required this.foregroundOnPrimary,
    required this.foregroundOnSecondary,
    required this.border,
  });

  /// Private constructor for the factory constructors
  const IbadahTheme._({
    required this.backgroundColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.foregroundOnBackground,
    required this.foregroundOnPrimary,
    required this.foregroundOnSecondary,
    required this.border,
  });

  /// The primary background color of the widget container.
  ///
  /// This color is used as the main background for the prayer time display.
  final Color backgroundColor;

  /// The primary color used for important UI elements.
  ///
  /// This color is typically used for highlighting the current or next prayer,
  /// buttons, and other prominent interactive elements.
  final Color primaryColor;

  /// The secondary color used for less prominent UI elements.
  ///
  /// This color is used for secondary information, borders, and supporting
  /// visual elements that complement the primary color.
  final Color secondaryColor;

  /// The text color to be used on top of the background color.
  ///
  /// This color ensures proper contrast and readability when text is displayed
  /// over the [backgroundColor].
  final Color foregroundOnBackground;

  /// The text color to be used on top of the primary color.
  ///
  /// This color ensures proper contrast and readability when text is displayed
  /// over the [primaryColor].
  final Color foregroundOnPrimary;

  /// The text color to be used on top of the secondary color.
  ///
  /// This color ensures proper contrast and readability when text is displayed
  /// over the [secondaryColor].
  final Color foregroundOnSecondary;

  /// The color used for borders and dividers throughout the widget.
  ///
  /// This color is used for visual separation between different sections
  /// and to create subtle boundaries in the UI.
  final Color border;
}
