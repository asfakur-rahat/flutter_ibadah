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

  const SalahTimeWidget({
    super.key,
    required this.iconPath,
    required this.title,
    required this.startTime,
    required this.ibadahTheme,
    required this.currentLocale,
    required this.supportedLocals,
    required this.ibadahStrings,
  });

  bool _isActive(DateTime? time) {
    if (time == null) return false;
    return DateTime.now().isBefore(time);
  }

  @override
  Widget build(BuildContext context) {
    final ibadahString = CommonUtils.getIbadahString(
      supportedLocals: supportedLocals,
      ibadahStrings: ibadahStrings,
      currentLocale: currentLocale,
    );
    return SizedBox(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _isActive(startTime)
                    ? ibadahTheme.foregroundOnBackground
                    : ibadahTheme.border,
                width: _isActive(startTime) ? 1.5 : 0.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: SvgPicture(
                  SvgAssetLoader(
                    iconPath,
                    packageName: 'flutter_ibadah',
                    colorMapper: SvgColorMapper(
                      toColor: _isActive(startTime)
                          ? ibadahTheme.foregroundOnBackground
                          : ibadahTheme.border,
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
                      ? ibadahTheme.foregroundOnBackground
                      : ibadahTheme.border,
                  fontSize: CommonUtils.getSp(14, context),
                ),
          ),
          // const SizedBox(height: 4),
          Text(
            CommonUtils.formatNumber(
              CommonUtils.formatTimeDefault(
                startTime,
                am: ibadahString.am,
                pm: ibadahString.pm,
              ),
              locale: currentLocale,
            ),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: _isActive(startTime)
                      ? ibadahTheme.foregroundOnBackground
                      : ibadahTheme.border,
                  fontSize: CommonUtils.getSp(14, context),
                ),
          ),
        ],
      ),
    );
  }
}
