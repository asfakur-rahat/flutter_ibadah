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
      final model = SalatTimeTableModel.fromJson(json);
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
    });

    test('copyWith returns updated model', () {
      final model = SalatTimeTableModel.fromJson(json);
      final updated =
          model.copyWith(fajr: DateTime.parse('2025-09-04T05:00:00.000'));
      expect(updated.fajr, DateTime.parse('2025-09-04T05:00:00.000'));
      expect(updated.sunrise, model.sunrise);
    });
  });
}
