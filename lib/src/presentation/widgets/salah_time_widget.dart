import 'package:flutter/material.dart';
import 'package:flutter_ibadah/src/core/utils/svg_color_mapper.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/utils/common_utils.dart';
import '../core/ibadah_strings.dart';
import '../core/ibadah_theme.dart';

class SalahTimeWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final DateTime? startTime;
  final IbadahTheme ibadahTheme;
  final List<String> supportedLocals;
  final List<IbadahStrings> ibadahStrings;
  final String currentLocale;
  final String currentPrayer;

  const SalahTimeWidget({
    super.key,
    required this.iconPath,
    required this.title,
    required this.startTime,
    required this.ibadahTheme,
    required this.currentLocale,
    required this.supportedLocals,
    required this.ibadahStrings,
    required this.currentPrayer,
  });

  bool _isActive(DateTime? time) {
    if (time == null) return false;
    return DateTime.now().isBefore(time);
  }

  bool _isCurrentPrayer() {
    return title == currentPrayer;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isActive(startTime)
                      ? _isCurrentPrayer()
                          ? ibadahTheme.currentPrayerColor
                          : ibadahTheme.upcomingPrayerColor
                      : ibadahTheme.previousPrayerColor,
                  width: _isActive(startTime) ? 1.5 : 0.5,
                ),
                color: const Color(0XffF8F8FF)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: SvgPicture(
                  SvgAssetLoader(
                    iconPath,
                    packageName: 'flutter_ibadah',
                    colorMapper: SvgColorMapper(
                      toColor: _isActive(startTime)
                          ? _isCurrentPrayer()
                              ? ibadahTheme.currentPrayerColor
                              : ibadahTheme.upcomingPrayerColor
                          : ibadahTheme.previousPrayerColor,
                    ),
                  ),
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: _isActive(startTime)
                      ? _isCurrentPrayer()
                          ? ibadahTheme.currentPrayerColor
                          : ibadahTheme.upcomingPrayerColor
                      : ibadahTheme.previousPrayerColor,
                  fontSize: CommonUtils.getSp(14, context),
                ),
          ),
          // const SizedBox(height: 4),
          Text(
            CommonUtils.formatNumber(
              CommonUtils.formatTimeDefault(
                startTime,
                am: CommonUtils.getIbadahString(
                  supportedLocals: supportedLocals,
                  ibadahStrings: ibadahStrings,
                  currentLocale: currentLocale,
                ).am,
                pm: CommonUtils.getIbadahString(
                  supportedLocals: supportedLocals,
                  ibadahStrings: ibadahStrings,
                  currentLocale: currentLocale,
                ).pm,
              ),
              locale: currentLocale,
            ),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: _isActive(startTime)
                      ? _isCurrentPrayer()
                          ? ibadahTheme.currentPrayerColor
                          : ibadahTheme.upcomingPrayerColor
                      : ibadahTheme.previousPrayerColor,
                  fontSize: CommonUtils.getSp(14, context),
                ),
          ),
        ],
      ),
    );
  }
}
