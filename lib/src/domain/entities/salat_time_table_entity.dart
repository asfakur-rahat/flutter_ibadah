import 'package:equatable/equatable.dart';

class SalatTimeTableEntity extends Equatable {
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
  final bool isFriday;

  /// The UTC offset of the city these times belong to.
  ///
  /// The prayer [DateTime]s are UTC instants; render them through
  /// `CommonUtils.inZone` with this offset so they read as the selected city's
  /// wall clock rather than the device's.
  final Duration utcOffset;

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
    this.isFriday = false,
    this.utcOffset = Duration.zero,
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
        isFriday,
        utcOffset,
      ];
}
