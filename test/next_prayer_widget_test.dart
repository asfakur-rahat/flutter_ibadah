import 'package:flutter/material.dart';
import 'package:flutter_ibadah/flutter_ibadah.dart';
import 'package:flutter_ibadah/src/domain/entities/salat_time_table_entity.dart';
import 'package:flutter_ibadah/src/presentation/widgets/next_prayer_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('NextPrayerWidget displays next prayer',
      (WidgetTester tester) async {
    final salatTimes = SalatTimeTableEntity(
      fajr: DateTime.now().add(Duration(hours: 1)),
      sunrise: DateTime.now().add(Duration(hours: 2)),
      dhuhr: DateTime.now().add(Duration(hours: 3)),
      asr: DateTime.now().add(Duration(hours: 4)),
      sunset: DateTime.now().add(Duration(hours: 5)),
      maghrib: DateTime.now().add(Duration(hours: 6)),
      isha: DateTime.now().add(Duration(hours: 7)),
      imsak: DateTime.now().add(Duration(hours: 8)),
      midnight: DateTime.now().add(Duration(hours: 9)),
      firstthird: DateTime.now().add(Duration(hours: 10)),
      lastthird: DateTime.now().add(Duration(hours: 11)),
    );

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: Center(
        child: NextPrayerWidget(
          salatTimes: salatTimes,
          ibadahTheme: IbadahTheme.light(),
          ibadahStrings: [IbadahStrings()],
          currentLocale: 'en',
          supportedLocals: ['en'],
          getNextPrayerName: (np) {},
        ),
      ),
    )));

    expect(find.byType(NextPrayerWidget), findsOneWidget);
  });
}
