import 'ibadah_defaults.dart';

class IbadahStrings {
  const IbadahStrings({
    this.ibadah = ibadahDefault,
    this.fajr = fajrDefault,
    this.dhuhr = dhuhrDefault,
    this.asr = asrDefault,
    this.maghrib = maghribDefault,
    this.isha = ishaDefault,
    this.fajrNextDay = fajrNextDayDefault,
    this.somethingWentWrong = somethingWentWrongDefault,
    this.upcoming = upcomingDefault,
    this.startIn = startInDefault,
  });

  final String ibadah;
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String fajrNextDay;
  final String somethingWentWrong;
  final String upcoming;
  final String startIn;
}

