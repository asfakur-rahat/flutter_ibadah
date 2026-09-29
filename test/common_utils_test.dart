import 'package:flutter_ibadah/flutter_ibadah.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ibadah/src/core/utils/common_utils.dart';

void main() {
  group('CommonUtils', () {
    test('formatDateDefault formats date correctly', () {
      final date = DateTime(2025, 9, 4);
      final formatted = CommonUtils.formatDateDefault(date);
      expect(formatted, '04 Sep 2025');
    });

    test('formatTimeDefault formats time correctly', () {
      final time = DateTime(2025, 9, 4, 15, 30);
      final formatted = CommonUtils.formatTimeDefault(
        time,
        am: 'AM',
        pm: 'PM',
      );
      expect(formatted, '3:30 PM');
    });

    test('formatTimeDefault renders in the city zone, not the device zone', () {
      // 05:37 in Toronto (-04:00). Whatever TZ the test machine is in, this
      // must read back as 5:37 AM.
      final instant = DateTime.parse('2026-09-29T05:37:00-04:00');
      expect(
        CommonUtils.formatTimeDefault(
          instant,
          am: 'AM',
          pm: 'PM',
          utcOffset: const Duration(hours: -4),
        ),
        '5:37 AM',
      );
    });

    test('formatTimeDefault handles a half-hour zone', () {
      final instant = DateTime.parse('2026-09-29T18:05:00+05:45');
      expect(
        CommonUtils.formatTimeDefault(
          instant,
          am: 'AM',
          pm: 'PM',
          utcOffset: const Duration(hours: 5, minutes: 45),
        ),
        '6:05 PM',
      );
    });

    test('formatTimeDefault renders midnight and noon as 12', () {
      expect(
        CommonUtils.formatTimeDefault(
          DateTime.parse('2026-09-29T00:10:00+06:00'),
          am: 'AM',
          pm: 'PM',
          utcOffset: const Duration(hours: 6),
        ),
        '12:10 AM',
      );
      expect(
        CommonUtils.formatTimeDefault(
          DateTime.parse('2026-09-29T12:10:00+06:00'),
          am: 'AM',
          pm: 'PM',
          utcOffset: const Duration(hours: 6),
        ),
        '12:10 PM',
      );
    });

    test('inZone shifts a UTC instant to the target wall clock', () {
      final instant = DateTime.utc(2026, 9, 29, 9, 37);
      final there = CommonUtils.inZone(instant, const Duration(hours: -4));
      expect(there.hour, 5);
      expect(there.minute, 37);
      expect(there.day, 29);
    });

    test('inZone can roll the calendar day backwards', () {
      final instant = DateTime.utc(2026, 9, 29, 2, 0);
      final there = CommonUtils.inZone(instant, const Duration(hours: -4));
      expect(there.day, 28);
      expect(there.hour, 22);
    });

    test('formatNumber localizes digits for the non-Latin locales', () {
      expect(CommonUtils.formatNumber('5:30', locale: 'bn'), '৫:৩০');
      expect(CommonUtils.formatNumber('5:30', locale: 'ar'), '٥:٣٠');
      expect(CommonUtils.formatNumber('5:30', locale: 'fa'), '۵:۳۰');
      expect(CommonUtils.formatNumber('5:30', locale: 'en'), '5:30');
    });

    test('formatNumber falls back to Latin digits for an unknown locale', () {
      expect(CommonUtils.formatNumber('5:30', locale: 'de'), '5:30');
    });

    test('getIbadahString falls back rather than throwing on a bad locale', () {
      const en = IbadahStrings();
      const bn = IbadahStrings(fajr: 'ফজর');

      expect(
        CommonUtils.getIbadahString(
          supportedLocals: const ['en', 'bn'],
          ibadahStrings: const [en, bn],
          currentLocale: 'bn',
        ).fajr,
        'ফজর',
      );
      // Not in supportedLocals: release builds must not RangeError here.
      expect(
        CommonUtils.getIbadahString(
          supportedLocals: const ['en', 'bn'],
          ibadahStrings: const [en, bn],
          currentLocale: 'fr',
        ).fajr,
        'Fajr',
      );
    });
  });
}
