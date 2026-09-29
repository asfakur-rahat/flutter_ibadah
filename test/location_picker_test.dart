import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ibadah/flutter_ibadah.dart';
import 'package:flutter_test/flutter_test.dart';

/// The location picker is opened by tapping the header chip, so nothing in the
/// suite reached it until these tests existed — which is how a debug assertion
/// in the sheet ("ListTile background color or ink splashes may be invisible")
/// survived into a release.
///
/// These tests deliberately open the sheet. `IbadahWidget` never resolves a
/// fetch here (the network path is avoided suite-wide), but the picker builds
/// from `locations` alone, so it renders fine.
void main() {
  /// `NextPrayerWidget` ticks once a second forever, so `pumpAndSettle` never
  /// settles anywhere in this widget's tree. Pump a bounded amount instead —
  /// enough to run a route transition.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  Future<void> pumpAndOpenPicker(
    WidgetTester tester, {
    List<IbadahLocation> locations = bangladeshDistricts,
    IbadahTheme? theme,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: IbadahWidget(
              ibadahTheme: theme ?? IbadahTheme.light(),
              currentLocale: 'en',
              locations: locations,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.location_pin));
    await settle(tester);
  }

  group('Location picker', () {
    testWidgets('opens without tripping a framework assertion',
        (WidgetTester tester) async {
      await pumpAndOpenPicker(tester);

      // The ListTiles must sit under a Material, or their ink splashes paint
      // behind the sheet's background and the framework asserts in debug.
      expect(find.byType(ListTile), findsWidgets);
      expect(
        find.ancestor(
          of: find.byType(ListTile).first,
          matching: find.byType(Material),
        ),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('lists the supplied locations, not a hardcoded district list',
        (WidgetTester tester) async {
      await pumpAndOpenPicker(
        tester,
        locations: const [
          IbadahLocation(city: 'Mecca', country: 'Saudi Arabia'),
          IbadahLocation(city: 'Toronto', country: 'Canada'),
        ],
      );

      // The header chip also renders the selected city, so Mecca appears
      // twice; Toronto only exists in the sheet.
      expect(find.text('Mecca'), findsWidgets);
      expect(find.text('Toronto'), findsOneWidget);
      expect(find.text('Dhaka'), findsNothing);
    });

    testWidgets('shows the country only when the list spans more than one',
        (WidgetTester tester) async {
      await pumpAndOpenPicker(
        tester,
        locations: const [
          IbadahLocation(city: 'Mecca', country: 'Saudi Arabia'),
          IbadahLocation(city: 'Toronto', country: 'Canada'),
        ],
      );
      expect(find.text('Saudi Arabia'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await settle(tester);

      // Single-country list: the country would be noise on every row.
      await pumpAndOpenPicker(
        tester,
        locations: const [
          IbadahLocation(city: 'Dhaka', country: 'Bangladesh'),
          IbadahLocation(city: 'Sylhet', country: 'Bangladesh'),
        ],
      );
      expect(find.text('Bangladesh'), findsNothing);
    });

    testWidgets('renders a label in place of the city when one is given',
        (WidgetTester tester) async {
      await pumpAndOpenPicker(
        tester,
        locations: const [
          IbadahLocation(
            city: 'Dhaka',
            country: 'Bangladesh',
            label: 'ঢাকা',
          ),
        ],
      );

      expect(find.text('ঢাকা'), findsWidgets);
      expect(find.text('Dhaka'), findsNothing);
    });

    testWidgets('filters as the user types', (WidgetTester tester) async {
      // An explicit short list: the default 64 districts are lazily built, so
      // an alphabetically late one is never laid out and cannot be asserted on.
      await pumpAndOpenPicker(
        tester,
        locations: const [
          IbadahLocation(city: 'Khulna', country: 'Bangladesh'),
          IbadahLocation(city: 'Sylhet', country: 'Bangladesh'),
        ],
      );

      expect(find.text('Sylhet'), findsOneWidget);

      await tester.enterText(find.byType(CupertinoSearchTextField), 'khul');
      await settle(tester);

      expect(find.text('Khulna'), findsWidgets);
      expect(find.text('Sylhet'), findsNothing);
    });

    testWidgets('matches on country as well as city',
        (WidgetTester tester) async {
      await pumpAndOpenPicker(
        tester,
        locations: const [
          IbadahLocation(city: 'Mecca', country: 'Saudi Arabia'),
          IbadahLocation(city: 'Toronto', country: 'Canada'),
        ],
      );

      await tester.enterText(find.byType(CupertinoSearchTextField), 'canada');
      await settle(tester);

      expect(find.text('Toronto'), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('tapping a location closes the sheet',
        (WidgetTester tester) async {
      await pumpAndOpenPicker(
        tester,
        locations: const [
          IbadahLocation(city: 'Mecca', country: 'Saudi Arabia'),
          IbadahLocation(city: 'Toronto', country: 'Canada'),
        ],
      );

      await tester.tap(find.text('Toronto'));
      await settle(tester);

      expect(find.byType(ListTile), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
