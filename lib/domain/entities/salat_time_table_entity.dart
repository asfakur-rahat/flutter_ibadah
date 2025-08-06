import 'package:equatable/equatable.dart';

class SalatTimeTableEntity extends Equatable{
  final DateTime? fajr;
  final DateTime? sunrise;
  final DateTime? dhuhr;
  final DateTime? asr;
  final DateTime? sunset;
  final DateTime? maghrib;
  final DateTime? isha;
  final DateTime? imsak;
  final DateTime? midnight;
  final DateTime? firstthird;
  final DateTime? lastthird;

  const SalatTimeTableEntity({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
    this.firstthird,
    this.lastthird,
  });

  @override
  List<Object?> get props => [
  fajr,
  sunrise,
  dhuhr,
  asr,
  sunset,
  maghrib,
  isha,
  imsak,
  midnight,
  firstthird,
  lastthird,
  ];
}
