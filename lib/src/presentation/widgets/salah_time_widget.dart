import 'package:flutter/material.dart';
import 'package:flutter_ibadah/src/core/utils/svg_color_mapper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/utils/common_utils.dart';

class SalahTimeWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final DateTime? startTime;

  const SalahTimeWidget({
    super.key,
    required this.iconPath,
    required this.title,
    required this.startTime,
  });

  bool _isActive(DateTime? time) {
    if (time == null) return false;
    return DateTime.now().isBefore(time);
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
                color:
                    _isActive(startTime)
                        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: .5)
                        : Colors.grey,
                width: _isActive(startTime) ? 2.5 : 0.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: SvgPicture(
                  SvgAssetLoader(
                    iconPath,
                    colorMapper: SvgColorMapper(
                      toColor:
                          _isActive(startTime)
                              ? Theme.of(context).colorScheme.onSurface
                              : Colors.grey,
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
              color:
                  _isActive(startTime)
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.grey,
              fontSize: CommonUtils.getSp(14, context),
            ),
          ),
          // const SizedBox(height: 4),
          Text(
            CommonUtils.formatNumber(
              CommonUtils.formatTimeDefault(startTime),
              locale: 'en',
            ),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color:
                  _isActive(startTime)
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.grey,
              fontSize: CommonUtils.getSp(14, context),
            ),
          ),
        ],
      ),
    );
  }
}
