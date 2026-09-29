import 'dart:convert';

/// A place to show prayer times for.
///
/// [city] and [country] are sent to the prayer-time API as a single
/// `"<city>,<country>"` address, so they should be spelled the way a geocoder
/// would expect them — English names work best.
///
/// ```dart
/// const IbadahLocation(city: 'Dhaka', country: 'Bangladesh')
/// const IbadahLocation(city: 'Mecca', country: 'Saudi Arabia')
/// ```
///
/// Use [label] when the text shown to the user should differ from the value
/// sent to the API, for example a localized name:
///
/// ```dart
/// const IbadahLocation(city: 'Dhaka', country: 'Bangladesh', label: 'ঢাকা')
/// ```
class IbadahLocation {
  /// The city, as the geocoder should receive it (e.g. `'Toronto'`).
  final String city;

  /// The country, as the geocoder should receive it (e.g. `'Canada'`).
  final String country;

  /// Optional display text, shown instead of [city] in the picker and header.
  ///
  /// Does not affect the API request.
  final String? label;

  const IbadahLocation({
    required this.city,
    required this.country,
    this.label,
  });

  /// What the user sees: [label] when given, otherwise [city].
  String get displayName => label ?? city;

  /// What the API receives as its `address` query parameter.
  String get address => '$city,$country';

  /// Whether [query] matches this location, used by the picker's search field.
  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return city.toLowerCase().contains(q) ||
        country.toLowerCase().contains(q) ||
        (label?.toLowerCase().contains(q) ?? false);
  }

  /// Serializes this location for the on-device cache.
  ///
  /// Round-trips through [decode].
  String encode() => jsonEncode({
        'city': city,
        'country': country,
        if (label != null) 'label': label,
      });

  /// Reads back a value produced by [encode], or `null` if it is unusable.
  ///
  /// A plain city name with no JSON structure is read as a city in
  /// [fallbackCountry]. That is how caches written before multi-country
  /// support — which stored a bare Bangladeshi district — are migrated.
  static IbadahLocation? decode(
    String? raw, {
    String fallbackCountry = 'Bangladesh',
  }) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        final city = decoded['city'];
        final country = decoded['country'];
        if (city is String &&
            city.isNotEmpty &&
            country is String &&
            country.isNotEmpty) {
          final label = decoded['label'];
          return IbadahLocation(
            city: city,
            country: country,
            label: label is String && label.isNotEmpty ? label : null,
          );
        }
      }
    } on FormatException {
      // Not JSON — fall through to the legacy bare-city reading below.
    }
    return IbadahLocation(city: raw, country: fallbackCountry);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IbadahLocation &&
          other.city == city &&
          other.country == country &&
          other.label == label;

  @override
  int get hashCode => Object.hash(city, country, label);

  @override
  String toString() => 'IbadahLocation($address)';
}
