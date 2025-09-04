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

  static String formatTimeDefault(
    DateTime? dateTime, {
    required String am,
    required String pm,
  }) {
    DateTime? convertedTime = dateTime?.toLocal();
    if (convertedTime == null) {
      return '-';
    }

    print('am -> $am   pm-> $pm');

    final formattedTime =
        "${convertedTime.hour % 12 == 0 ? 12 : convertedTime.hour % 12}"
        ":${convertedTime.minute.toString().padLeft(2, '0')}"
        " ${convertedTime.hour >= 12 ? pm : am}";

    return formattedTime;
  }

  static debugLog(String logMessage) {
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
    return ibadahStrings[supportedLocals.indexOf(currentLocale)];
  }
}

const numberMap = {
  "0": {"en": "0", "bn": "০"},
  "1": {"en": "1", "bn": "১"},
  "2": {"en": "2", "bn": "২"},
  "3": {"en": "3", "bn": "৩"},
  "4": {"en": "4", "bn": "৪"},
  "5": {"en": "5", "bn": "৫"},
  "6": {"en": "6", "bn": "৬"},
  "7": {"en": "7", "bn": "৭"},
  "8": {"en": "8", "bn": "৮"},
  "9": {"en": "9", "bn": "৯"}
};
