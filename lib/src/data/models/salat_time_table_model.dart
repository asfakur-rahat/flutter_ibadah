import '../../domain/entities/salat_time_table_entity.dart';

class SalatTimeTableModel {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime sunset;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime imsak;
  final DateTime midnight;
  final DateTime firstthird;
  final DateTime lastthird;
  final bool isFriday;

  /// The selected city's UTC offset, recovered from the ISO8601 response.
  final Duration utcOffset;

  const SalatTimeTableModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.imsak,
    required this.midnight,
    required this.firstthird,
    required this.lastthird,
    required this.isFriday,
    this.utcOffset = Duration.zero,
  });

  /// Reads the UTC offset out of an ISO8601 timestamp such as
  /// `2026-09-29T05:37:00-04:00`.
  ///
  /// This has to happen on the raw string: `DateTime.parse` converts an
  /// offset-bearing timestamp to UTC and discards the offset, so by the time we
  /// hold a [DateTime] there is no way to recover which city it belongs to.
  static Duration parseUtcOffset(String? iso8601) {
    if (iso8601 == null) return Duration.zero;
    if (iso8601.endsWith('Z')) return Duration.zero;
    final match = RegExp(r'([+-])(\d{2}):?(\d{2})$').firstMatch(iso8601.trim());
    if (match == null) return Duration.zero;
    final offset = Duration(
      hours: int.parse(match.group(2)!),
      minutes: int.parse(match.group(3)!),
    );
    return match.group(1) == '-' ? -offset : offset;
  }

  factory SalatTimeTableModel.fromJson(dynamic json, dynamic isFriday) {
    return SalatTimeTableModel(
      utcOffset: parseUtcOffset(json['Fajr'] as String?),
      fajr: DateTime.parse(json['Fajr']),
      sunrise: DateTime.parse(json['Sunrise']),
      dhuhr: DateTime.parse(json['Dhuhr']),
      asr: DateTime.parse(json['Asr']),
      sunset: DateTime.parse(json['Sunset']),
      maghrib: DateTime.parse(json['Maghrib']),
      isha: DateTime.parse(json['Isha']),
      imsak: DateTime.parse(json['Imsak']),
      midnight: DateTime.parse(json['Midnight']),
      firstthird: DateTime.parse(json['Firstthird']),
      lastthird: DateTime.parse(json['Lastthird']),
      isFriday: isFriday,
    );
  }

  SalatTimeTableModel copyWith({
    DateTime? fajr,
    DateTime? sunrise,
    DateTime? dhuhr,
    DateTime? asr,
    DateTime? sunset,
    DateTime? maghrib,
    DateTime? isha,
    DateTime? imsak,
    DateTime? midnight,
    DateTime? firstthird,
    DateTime? lastthird,
    bool? isFriday,
    Duration? utcOffset,
  }) {
    return SalatTimeTableModel(
      fajr: fajr ?? this.fajr,
      sunrise: sunrise ?? this.sunrise,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      sunset: sunset ?? this.sunset,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
      imsak: imsak ?? this.imsak,
      midnight: midnight ?? this.midnight,
      firstthird: firstthird ?? this.firstthird,
      lastthird: lastthird ?? this.lastthird,
      isFriday: isFriday ?? this.isFriday,
      utcOffset: utcOffset ?? this.utcOffset,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Fajr'] = fajr;
    map['Sunrise'] = sunrise;
    map['Dhuhr'] = dhuhr;
    map['Asr'] = asr;
    map['Sunset'] = sunset;
    map['Maghrib'] = maghrib;
    map['Isha'] = isha;
    map['Imsak'] = imsak;
    map['Midnight'] = midnight;
    map['Firstthird'] = firstthird;
    map['Lastthird'] = lastthird;
    map['isFriday'] = isFriday;
    return map;
  }

  SalatTimeTableEntity toEntity() {
    return SalatTimeTableEntity(
      fajr: fajr,
      sunrise: sunrise,
      dhuhr: dhuhr,
      asr: asr,
      sunset: sunset,
      maghrib: maghrib,
      isha: isha,
      imsak: imsak,
      midnight: midnight,
      firstthird: firstthird,
      lastthird: lastthird,
      isFriday: isFriday,
      utcOffset: utcOffset,
    );
  }
}
