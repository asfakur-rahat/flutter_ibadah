import 'ibadah_defaults.dart';


/// A class that holds all the string resources used in the Ibadah application.
///
/// This class provides a centralized way to manage all UI strings, making it easier
/// to maintain and support multiple languages. Each string has a default value
/// that can be overridden for different locales.
///
/// Example usage with default values:
/// ```dart
/// const defaultStrings = IbadahStrings();
/// // defaultStrings.ibadah == 'Ibadah'
/// // defaultStrings.fajr == 'Fajr'
/// // defaultStrings.dhuhr == 'Dhuhr'
/// // defaultStrings.asr == 'Asr'
/// // defaultStrings.maghrib == 'Maghrib'
/// // defaultStrings.isha == 'Isha'
/// // defaultStrings.fajrNextDay == 'Fajr (next day)'
/// // defaultStrings.somethingWentWrong == 'Something went wrong'
/// // defaultStrings.upcoming == 'Upcoming'
/// // defaultStrings.startIn == 'Start in'
/// // defaultStrings.am == 'AM'
/// // defaultStrings.pm == 'PM'
/// // defaultStrings.searchHintText == 'Search district'
/// ```
class IbadahStrings {
  /// Creates an instance of [IbadahStrings] with customizable string values.
  ///
  /// All parameters are optional and will default to English strings if not provided.
  /// Default values are shown in the example below.
  ///
  /// Example of customizing strings:
  /// ```dart
  /// const bnStrings = IbadahStrings(
  ///   ibadah: 'ইবাদাত',
  ///   fajr: 'ফজর',
  ///   dhuhr: 'জোহর',
  ///   asr: 'আসর',
  ///   maghrib: 'মাগরিব',
  ///   isha: 'ইশা',
  ///   fajrNextDay: 'পরদিনের ফজর',
  ///   somethingWentWrong: 'কিছু একটা সমস্যা হয়েছে',
  ///   upcoming: 'আসন্ন',
  ///   startIn: 'শুরু হবে',
  ///   am: 'সকাল',
  ///   pm: 'বিকাল',
  ///   searchHintText: 'জেলা খুঁজুন',
  /// );
  /// ```
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
    this.am = amDefault,
    this.pm = pmDefault,
    this.searchHintText = searchHintTextDefault,
  });

  /// The app name or title.
  /// Default: 'Ibadah'
  final String ibadah;

  /// The name of the Fajr prayer.
  /// Default: 'Fajr'
  final String fajr;

  /// The name of the Dhuhr prayer.
  /// Default: 'Dhuhr'
  final String dhuhr;

  /// The name of the Asr prayer.
  /// Default: 'Asr'
  final String asr;

  /// The name of the Maghrib prayer.
  /// Default: 'Maghrib'
  final String maghrib;

  /// The name of the Isha prayer.
  /// Default: 'Isha'
  final String isha;

  /// The label for next day's Fajr prayer.
  /// Default: 'Fajr (next day)'
  final String fajrNextDay;

  /// A generic error message.
  /// Default: 'Something went wrong'
  final String somethingWentWrong;

  /// Label for upcoming events or prayers.
  /// Default: 'Upcoming'
  final String upcoming;

  /// Label indicating when something will start.
  /// Default: 'Start in'
  final String startIn;

  /// AM time indicator.
  /// Default: 'AM'
  final String am;

  /// PM time indicator.
  /// Default: 'PM'
  final String pm;

  /// Hint text for search input fields.
  /// Default: 'Search district'
  final String searchHintText;
}

