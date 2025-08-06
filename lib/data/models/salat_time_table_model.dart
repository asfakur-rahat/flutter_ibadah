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
  });

  factory SalatTimeTableModel.fromJson(dynamic json) {
    return SalatTimeTableModel(
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
    );
  }
}
