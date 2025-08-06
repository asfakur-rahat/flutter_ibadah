import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonUtils {
  static String formatWithCommas(num number, {bool keepDecimal = true}) {
    List<String> parts = number.toStringAsFixed(2).split('.');

    String integerPart = parts[0];
    String formattedIntegerPart = integerPart.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
    if (keepDecimal) {
      return '$formattedIntegerPart.${parts[1]}';
    }
    return formattedIntegerPart;
  }

  static int getGreetings() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 1; //'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 2; //'Good Afternoon';
    } else {
      return 3; //'Good Evening';
    }
  }

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

  static String formatTimeDefault(DateTime? dateTime) {
    DateTime? convertedTime = dateTime?.toLocal();
    if (convertedTime == null) {
      return '-';
    }

    final formattedTime =
        "${convertedTime.hour % 12 == 0 ? 12 : convertedTime.hour % 12}"
        ":${convertedTime.minute.toString().padLeft(2, '0')}"
        " ${convertedTime.hour >= 12 ? 'PM' : 'AM'}";

    return formattedTime;
  }

  static String truncateString(String input, {int? length}) {
    if (input.length > (length ?? 20)) {
      return '${input.substring(0, (length ?? 20))}...';
    }
    return input;
  }

  static String getAmountString(num? number, {bool keepDecimal = true}) {
    if (number != null) {
      String formatted = formatWithCommas(number, keepDecimal: keepDecimal);
      return "৳$formatted";
    } else {
      return '৳ -';
    }
  }

  static String getAmountStringForDropdown(num? number, {bool keepDecimal = true}){
    if (number != null) {
      String formatted = formatWithCommas(number, keepDecimal: keepDecimal);
      return formatted;
    } else {
      return '-';
    }
  }

  static addSpaceToPascal(String? str) {
    if (str == null) return "----";

    return str.replaceAllMapped(
      RegExp(r'(?<=[a-z])(?=[A-Z])'),
      (match) => ' ',
    );
  }

  static bool isValidEmailAddress(String email) {
    final RegExp emailRegExp = RegExp(
        r"^(?!.*\.\.)[a-zA-Z0-9](?:[a-zA-Z0-9._%+-]{0,62}[a-zA-Z0-9])?@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    );
    return emailRegExp.hasMatch(email);
  }

  static String? validatePhoneNumber(String mobile) {
    if (mobile.length != 11) {
      return "Mobile Number must contain 11 digit";
    } else if (!mobile.startsWith('01')) {
      return "Please Enter a valid mobile number";
    } else {
      return null;
    }
  }

  static bool containsSpecialCharacter(String text) {
    // This RegExp matches any character that is NOT a letter, number, or space
    final specialCharRegex = RegExp(r'[^\w\s]');
    return specialCharRegex.hasMatch(text);
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

  static double getDp(num val, BuildContext context) {
    double width = val * MediaQuery.sizeOf(context).width / 100;
    return val * (width * 160) / MediaQuery.of(context).devicePixelRatio;
  }



  static TimeOfDay addTime(TimeOfDay time, {required Duration addedTime}) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute)
            .add(addedTime);

    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }


  static String convertDictionaryToString({
    required Map<String, dynamic> dictionary,
  }) {
    int index = 0;
    List<String?> stringList = dictionary.entries.map((e) {
      if (dictionary.length - 1 == index) {
        index++;
        return "${e.key}. ${e.value}";
      } else {
        index++;
        return "${e.key}. ${e.value}\n";
      }
    }).toList();
    return stringList.join("");
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

  static T? safeFirstWhere<T>(List<T>? list, bool Function(T) test) {
    if (list == null) return null;
    for (var item in list) {
      if (test(item)) return item;
    }
    return null;
  }

  static bool isValidName(String input) {
    final nameRegex = RegExp(r'^[a-zA-Z\u0980-\u09FF.\- ]+$');
    return nameRegex.hasMatch(input);
  }

  static String? validateContact(String input) {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    final onlyDigits = RegExp(r'^\d+$');

    final isEmail = emailRegex.hasMatch(input);
    final isDigitsOnly = onlyDigits.hasMatch(input);

    if ((isEmail && isDigitsOnly) || (!isEmail && !isDigitsOnly)) {
      return 'Contact must be a valid phone number or email';
    }

    if (isDigitsOnly) {
      return validatePhoneNumber(input) ?? "Invalid contact input";
    }

    if (isEmail) {
      if (!isValidEmailAddress(input)) {
        return "Invalid email address";
      }
    }

    return null;
  }

  static bool isStoreVersionNewer({required String currentAppVersion, required String storeVersion}) {
    List<int> current = currentAppVersion.split('.').map(int.parse).toList();
    List<int> store = storeVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      if (store[i] > current[i]) return true;
      if (store[i] < current[i]) return false;
    }

    return false; // versions are equal
  }


}

const numberMap = {
  "0": {
    "en": "0",
    "bn": "০"
  },
  "1": {
    "en": "1",
    "bn": "১"
  },
  "2": {
    "en": "2",
    "bn": "২"
  },
  "3": {
    "en": "3",
    "bn": "৩"
  },
  "4": {
    "en": "4",
    "bn": "৪"
  },
  "5": {
    "en": "5",
    "bn": "৫"
  },
  "6": {
    "en": "6",
    "bn": "৬"
  },
  "7": {
    "en": "7",
    "bn": "৭"
  },
  "8": {
    "en": "8",
    "bn": "৮"
  },
  "9": {
    "en": "9",
    "bn": "৯"
  }
};
