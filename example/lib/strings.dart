import 'package:flutter_ibadah/flutter_ibadah.dart';

/// The locales this demo offers, in the order [demoStrings] expects.
///
/// `IbadahWidget` looks strings up positionally, so these two lists must stay
/// index-aligned.
const List<String> demoLocales = ['en', 'bn', 'ar'];

const List<IbadahStrings> demoStrings = [
  IbadahStrings(), // English — all defaults
  bnStrings,
  arStrings,
];

const IbadahStrings bnStrings = IbadahStrings(
  ibadah: 'ইবাদত',
  fajr: 'ফজর',
  dhuhr: 'যুহর',
  jummah: 'জুম্মা',
  asr: 'আসর',
  maghrib: 'মাগরিব',
  isha: 'ইশা',
  fajrNextDay: 'ফজর (পরের দিন)',
  somethingWentWrong: 'কিছু ভুল হয়েছে',
  upcoming: 'আসন্ন',
  startIn: 'শুরু হবে',
  am: 'সকাল',
  pm: 'বিকাল',
  searchHintText: 'অবস্থান খুঁজুন',
  retry: 'আবার চেষ্টা করুন',
  locationNotFound: 'অবস্থানটি খুঁজে পাওয়া যায়নি',
);

/// Arabic, included mainly to exercise the Arabic-Indic digit mapping —
/// prayer times render as ٥:٣٠ rather than 5:30.
const IbadahStrings arStrings = IbadahStrings(
  ibadah: 'عبادة',
  fajr: 'الفجر',
  dhuhr: 'الظهر',
  jummah: 'الجمعة',
  asr: 'العصر',
  maghrib: 'المغرب',
  isha: 'العشاء',
  fajrNextDay: 'الفجر (غدًا)',
  somethingWentWrong: 'حدث خطأ ما',
  upcoming: 'القادم',
  startIn: 'يبدأ خلال',
  am: 'ص',
  pm: 'م',
  searchHintText: 'ابحث عن موقع',
  retry: 'أعد المحاولة',
  locationNotFound: 'تعذر العثور على هذا الموقع',
);
