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
  });
}
