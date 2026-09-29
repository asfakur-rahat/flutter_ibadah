import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ibadah/src/data/models/salat_time_table_model.dart';

void main() {
  group('SalatTimeTableModel', () {
    final json = {
      'Fajr': '2025-09-04T04:30:00.000',
      'Sunrise': '2025-09-04T05:45:00.000',
      'Dhuhr': '2025-09-04T12:00:00.000',
      'Asr': '2025-09-04T15:30:00.000',
      'Sunset': '2025-09-04T18:15:00.000',
      'Maghrib': '2025-09-04T18:20:00.000',
      'Isha': '2025-09-04T19:45:00.000',
      'Imsak': '2025-09-04T04:20:00.000',
      'Midnight': '2025-09-05T00:00:00.000',
      'Firstthird': '2025-09-04T22:00:00.000',
      'Lastthird': '2025-09-05T02:00:00.000',
    };

    test('fromJson creates correct model', () {
      final model = SalatTimeTableModel.fromJson(json, false);
      expect(model.fajr, DateTime.parse(json['Fajr']!));
      expect(model.sunrise, DateTime.parse(json['Sunrise']!));
      expect(model.dhuhr, DateTime.parse(json['Dhuhr']!));
      expect(model.asr, DateTime.parse(json['Asr']!));
      expect(model.sunset, DateTime.parse(json['Sunset']!));
      expect(model.maghrib, DateTime.parse(json['Maghrib']!));
      expect(model.isha, DateTime.parse(json['Isha']!));
      expect(model.imsak, DateTime.parse(json['Imsak']!));
      expect(model.midnight, DateTime.parse(json['Midnight']!));
      expect(model.firstthird, DateTime.parse(json['Firstthird']!));
      expect(model.lastthird, DateTime.parse(json['Lastthird']!));
      expect(model.isFriday, false);
    });

    test('records the city UTC offset from the ISO8601 response', () {
      final toronto = Map<String, String>.from(json).map(
        (k, v) => MapEntry(k, v.replaceFirst('.000', '-04:00')),
      );
      final model = SalatTimeTableModel.fromJson(toronto, false);
      expect(model.utcOffset, const Duration(hours: -4));
    });

    test('records a positive offset', () {
      final dhaka = Map<String, String>.from(json).map(
        (k, v) => MapEntry(k, v.replaceFirst('.000', '+06:00')),
      );
      expect(
        SalatTimeTableModel.fromJson(dhaka, false).utcOffset,
        const Duration(hours: 6),
      );
    });

    test('parseUtcOffset handles Z, half-hour zones and missing offsets', () {
      expect(
        SalatTimeTableModel.parseUtcOffset('2026-09-29T04:30:00Z'),
        Duration.zero,
      );
      expect(
        SalatTimeTableModel.parseUtcOffset('2026-09-29T04:30:00+05:45'),
        const Duration(hours: 5, minutes: 45),
      );
      expect(
        SalatTimeTableModel.parseUtcOffset('2026-09-29T04:30:00-03:30'),
        const Duration(hours: -3, minutes: -30),
      );
      expect(
        SalatTimeTableModel.parseUtcOffset('2026-09-29T04:30:00.000'),
        Duration.zero,
      );
      expect(SalatTimeTableModel.parseUtcOffset(null), Duration.zero);
    });

    test('DateTime.parse discards the offset, which is why we keep it', () {
      // This is the premise the whole timezone handling rests on: an
      // offset-bearing timestamp comes back as a UTC instant, so the city's
      // offset has to be read off the raw string before parsing.
      final parsed = DateTime.parse('2026-09-29T05:37:00-04:00');
      expect(parsed.isUtc, isTrue);
      expect(parsed.timeZoneOffset, Duration.zero);
      expect(parsed, DateTime.utc(2026, 9, 29, 9, 37));
    });

    test('copyWith returns updated model', () {
      final model = SalatTimeTableModel.fromJson(json, false);
      final updated =
          model.copyWith(fajr: DateTime.parse('2025-09-04T05:00:00.000'));
      expect(updated.fajr, DateTime.parse('2025-09-04T05:00:00.000'));
      expect(updated.sunrise, model.sunrise);
    });
  });
}
