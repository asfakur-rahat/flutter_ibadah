import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ibadah/src/core/utils/common_utils.dart';
import 'package:flutter_ibadah/src/domain/entities/salat_time_table_entity.dart';

import '../core/ibadah_strings.dart';
import '../core/ibadah_theme.dart';

class NextPrayerWidget extends StatefulWidget {
  final SalatTimeTableEntity salatTimes;
  final IbadahTheme ibadahTheme;
  final List<IbadahStrings> ibadahStrings;
  final List<String> supportedLocals;
  final String currentLocale;

  const NextPrayerWidget({
    super.key,
    required this.salatTimes,
    required this.ibadahTheme,
    required this.ibadahStrings,
    required this.supportedLocals,
    required this.currentLocale,
  });

  @override
  State<NextPrayerWidget> createState() => _NextPrayerWidgetState();
}

class _NextPrayerWidgetState extends State<NextPrayerWidget> {
  late Timer _timer;
  String _nextPrayerName = '';
  DateTime? _nextPrayerTime;
  late IbadahStrings ibadahStrings;

  @override
  void initState() {
    super.initState();
    ibadahStrings = CommonUtils.getIbadahString(
      supportedLocals: widget.supportedLocals,
      ibadahStrings: widget.ibadahStrings,
      currentLocale: widget.currentLocale,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateNextPrayer();
    });
  }

  @override
  void didUpdateWidget(covariant NextPrayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    ibadahStrings = CommonUtils.getIbadahString(
      supportedLocals: widget.supportedLocals,
      ibadahStrings: widget.ibadahStrings,
      currentLocale: widget.currentLocale,
    );
  }

  void _updateNextPrayer() {
    final now = DateTime.now();

    final prayerTimes = {
      ibadahStrings.fajr: widget.salatTimes.fajr,
      ibadahStrings.dhuhr: widget.salatTimes.dhuhr,
      ibadahStrings.asr: widget.salatTimes.asr,
      ibadahStrings.maghrib: widget.salatTimes.maghrib,
      ibadahStrings.isha: widget.salatTimes.isha,
    };

    final upcoming = prayerTimes.entries
        .where((entry) => entry.value?.isAfter(now) ?? false)
        .toList()
      ..sort((a, b) => a.value!.compareTo(b.value!));

    if (upcoming.isNotEmpty) {
      setState(() {
        _nextPrayerName = upcoming.first.key;
        _nextPrayerTime = upcoming.first.value;
      });
    } else {
      setState(() {
        _nextPrayerName = ibadahStrings.fajrNextDay;
        _nextPrayerTime = widget.salatTimes.fajr?.add(const Duration(days: 1));
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _getNextPrayerName(String name, BuildContext context) {
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return _nextPrayerTime == null
        ? Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text(ibadahStrings.somethingWentWrong)],
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${ibadahStrings.upcoming}: ${_getNextPrayerName(_nextPrayerName, context) ?? "--"}',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '( ${CommonUtils.formatNumber(
                      CommonUtils.formatTimeDefault(
                        _nextPrayerTime,
                        am: ibadahStrings.am,
                        pm: ibadahStrings.pm,
                      ),
                      locale: widget.currentLocale,
                    )} )',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${ibadahStrings.startIn}: ${CommonUtils.formatNumber(
                  _formatDuration(_nextPrayerTime?.difference(DateTime.now()) ??
                      const Duration(seconds: 0)),
                  locale: widget.currentLocale,
                )}',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.grey[500]),
              ),
            ],
          );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
