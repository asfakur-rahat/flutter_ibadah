import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ibadah/flutter_ibadah.dart';
import 'package:intl/intl.dart';

class CommonUtils {
  static String formatDateDefault(DateTime? time,
      {String? pattern, String Function()? orElse}) {
    if (time == null) {
      if (orElse != null) {
        return orElse();
      } else {
        return "-";
      }
    }

    return DateFormat(pattern ?? "dd MMM yyyy").format(time);
  }

  static String toDateOnly(DateTime time) {
    return DateFormat("yyyy-MM-dd").format(time);
  }

  /// Re-reads [instant] as wall-clock time at [offset] from UTC.
  ///
  /// The returned [DateTime] is a naive value whose fields (hour, day, ...)
  /// read as the target city's clock. It is for display and calendar-day
  /// arithmetic only — never compare it against `DateTime.now()`.
  static DateTime inZone(DateTime instant, Duration offset) =>
      instant.toUtc().add(offset);

  static String formatTimeDefault(
    DateTime? dateTime, {
    required String am,
    required String pm,
    Duration? utcOffset,
  }) {
    if (dateTime == null) {
      return '-';
    }
    // Render in the selected city's zone, not the device's. `utcOffset` comes
    // from the API response; falling back to `toLocal()` keeps the old
    // behaviour for callers that have no timetable yet.
    final DateTime convertedTime =
        utcOffset != null ? inZone(dateTime, utcOffset) : dateTime.toLocal();

    final formattedTime =
        "${convertedTime.hour % 12 == 0 ? 12 : convertedTime.hour % 12}"
        ":${convertedTime.minute.toString().padLeft(2, '0')}"
        " ${convertedTime.hour >= 12 ? pm : am}";

    return formattedTime;
  }

  static void debugLog(String logMessage) {
    if (kDebugMode) {
      log(logMessage);
    }
  }

  static double getSp(num val, BuildContext context) {
    double height = val * MediaQuery.sizeOf(context).height / 100;
    double width = val * MediaQuery.sizeOf(context).width / 100;
    return val *
        (((width + height) +
                (MediaQuery.of(context).devicePixelRatio *
                    MediaQuery.of(context).size.aspectRatio)) /
            2.08) /
        100;
  }

  static String formatNumber(String number, {String locale = 'en'}) {
    final buffer = StringBuffer();

    for (var char in number.split('')) {
      if (numberMap.containsKey(char)) {
        buffer.write(numberMap[char]![locale] ??
            char); // fallback to original if locale missing
      } else {
        buffer.write(char); // keep non-digit characters as-is
      }
    }

    return buffer.toString();
  }

  static IbadahStrings getIbadahString({
    required List<String> supportedLocals,
    required List<IbadahStrings> ibadahStrings,
    required String currentLocale,
  }) {
    // IbadahWidget asserts that currentLocale is in supportedLocals, but
    // asserts are stripped in release builds — fall back to the first entry
    // instead of throwing a RangeError on indexOf's -1.
    final index = supportedLocals.indexOf(currentLocale);
    if (index < 0 || index >= ibadahStrings.length) {
      return ibadahStrings.first;
    }
    return ibadahStrings[index];
  }
}

const numberMap = {
  "0": {"en": "0", "bn": "০", "ar": "٠", "fa": "۰", "ur": "۰"},
  "1": {"en": "1", "bn": "১", "ar": "١", "fa": "۱", "ur": "۱"},
  "2": {"en": "2", "bn": "২", "ar": "٢", "fa": "۲", "ur": "۲"},
  "3": {"en": "3", "bn": "৩", "ar": "٣", "fa": "۳", "ur": "۳"},
  "4": {"en": "4", "bn": "৪", "ar": "٤", "fa": "۴", "ur": "۴"},
  "5": {"en": "5", "bn": "৫", "ar": "٥", "fa": "۵", "ur": "۵"},
  "6": {"en": "6", "bn": "৬", "ar": "٦", "fa": "۶", "ur": "۶"},
  "7": {"en": "7", "bn": "৭", "ar": "٧", "fa": "۷", "ur": "۷"},
  "8": {"en": "8", "bn": "৮", "ar": "٨", "fa": "۸", "ur": "۸"},
  "9": {"en": "9", "bn": "৯", "ar": "٩", "fa": "۹", "ur": "۹"}
};
