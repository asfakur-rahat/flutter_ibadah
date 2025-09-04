import 'package:flutter/material.dart';
import 'package:flutter_ibadah/src/presentation/widgets/ibadah_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sample Tests', () {
    test('String contains Upcoming', () {
      final input = 'adadasaaUpcomingdadasdsd';
      final regex = RegExp(r'Upcoming');
      expect(regex.hasMatch(input), isTrue);
    });

    test('String does not contain Upcoming', () {
      final input = 'adadasaadadasdsd';
      final regex = RegExp(r'Upcoming');
      expect(regex.hasMatch(input), isFalse);
    });
  });

  group('IbadahWidget Tests', () {
    testWidgets('IbadahWidget builds', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: IbadahWidget(
                ibadahTheme: IbadahTheme.light(),
                currentLocale: 'en',
              ),
            ),
          ),
        ),
      );
      expect(find.byType(IbadahWidget), findsOneWidget);
    });
  });
}
