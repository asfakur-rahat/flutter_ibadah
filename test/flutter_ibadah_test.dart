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

    testWidgets('attaches and detaches the controller it is given',
        (WidgetTester tester) async {
      final controller = IbadahController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: IbadahWidget(
                controller: controller,
                ibadahTheme: IbadahTheme.light(),
                currentLocale: 'en',
              ),
            ),
          ),
        ),
      );
      expect(controller.isAttached, isTrue);

      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
      expect(controller.isAttached, isFalse);
    });

    testWidgets('swapping the controller re-attaches',
        (WidgetTester tester) async {
      final first = IbadahController();
      final second = IbadahController();
      addTearDown(first.dispose);
      addTearDown(second.dispose);

      Widget build(IbadahController controller) => MaterialApp(
            home: Scaffold(
              body: Center(
                child: IbadahWidget(
                  controller: controller,
                  ibadahTheme: IbadahTheme.light(),
                  currentLocale: 'en',
                ),
              ),
            ),
          );

      await tester.pumpWidget(build(first));
      expect(first.isAttached, isTrue);

      await tester.pumpWidget(build(second));
      expect(first.isAttached, isFalse);
      expect(second.isAttached, isTrue);

      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
    });
  });
}
