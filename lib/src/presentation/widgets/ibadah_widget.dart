import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ibadah/src/core/local/hive_service.dart';
import 'package:flutter_ibadah/src/core/utils/common_utils.dart';
import 'package:flutter_ibadah/src/core/utils/svg_color_mapper.dart';
import 'package:flutter_ibadah/src/domain/entities/salat_time_table_entity.dart';
import 'package:flutter_ibadah/src/presentation/bloc/ibadah_bloc.dart';
import 'package:flutter_ibadah/src/presentation/core/ibadah_strings.dart';
import 'package:flutter_ibadah/src/presentation/core/ibadah_theme.dart';
import 'package:flutter_ibadah/src/presentation/widgets/district_selection_bottom_sheet.dart';
import 'package:flutter_ibadah/src/presentation/widgets/salah_time_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';

import 'next_prayer_widget.dart';

export 'package:flutter_ibadah/src/presentation/core/ibadah_strings.dart';
export 'package:flutter_ibadah/src/presentation/core/ibadah_theme.dart';

class IbadahWidget extends StatefulWidget {
  IbadahWidget({
    super.key,
    required this.ibadahTheme,
    required this.currentLocale,
    this.supportedLocals = const ['en'],
    this.ibadahStrings = const [IbadahStrings()],
  })  : assert(
          supportedLocals.length == ibadahStrings.length,
          'supportedLocals and ibadahStrings must have the same length',
        ),
        assert(
          supportedLocals.contains(currentLocale),
          'currentLocale must be present in supportedLocals',
        );

  final IbadahTheme ibadahTheme;
  final List<IbadahStrings> ibadahStrings;
  final List<String> supportedLocals;
  final String currentLocale;

  @override
  State<IbadahWidget> createState() => _IbadahWidgetState();
}

class _IbadahWidgetState extends State<IbadahWidget>
    with TickerProviderStateMixin {
  //late Alerts _alerts;
  late Timer _timer;
  final IbadahBloc _ibadahBloc = IbadahBloc();
  final ValueNotifier<String> selectedDistrict = ValueNotifier("Dhaka");
  final ValueNotifier<SalatTimeTableEntity> salatTimeEntity = ValueNotifier(
    const SalatTimeTableEntity(),
  );
  final ValueNotifier<bool> periodicRefresh = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    CommonUtils.debugLog('Inside ibadah screen initstate');
    _initHive();
    _timer = Timer.periodic(const Duration(minutes: 30), (_) {
      periodicRefresh.value = !periodicRefresh.value;
    });
  }

  @override
  void didUpdateWidget(covariant IbadahWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  void _initHive() async {
    await Hive.initFlutter();
    await HiveService.instance.init();
    _initSalatTime();
  }

  void _initSalatTime() {
    String? district = HiveService.instance.retrieveData("district");
    _ibadahBloc.selectedDistrict = district ?? "Dhaka";
    selectedDistrict.value = district ?? "Dhaka";
    _ibadahBloc.add(FetchSalatTime(district: _ibadahBloc.selectedDistrict));
  }

  @override
  void dispose() {
    super.dispose();
    periodicRefresh.dispose();
    selectedDistrict.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final finalStrings = CommonUtils.getIbadahString(
      supportedLocals: widget.supportedLocals,
      ibadahStrings: widget.ibadahStrings,
      currentLocale: widget.currentLocale,
    );
    return BlocProvider<IbadahBloc>(
      create: (_) => _ibadahBloc,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.ibadahTheme.foregroundOnPrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.ibadahTheme.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/ic_mosque.svg",
                        height: 24,
                        package: 'flutter_ibadah',
                        colorMapper: SvgColorMapper(
                          toColor: widget.ibadahTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        finalStrings.ibadah,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: widget.ibadahTheme.foregroundOnPrimary,
                        barrierColor: const Color(0x1A1925A6),
                        enableDrag: true,
                        isDismissible: true,
                        isScrollControlled: true,
                        builder: (context) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: PopScope(
                            canPop: true,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 14,
                                sigmaY: 14,
                              ),
                              child: SafeArea(
                                child: Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 36,
                                        width: MediaQuery.sizeOf(context).width,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: widget.ibadahTheme
                                                .foregroundOnPrimary,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(24),
                                              topRight: Radius.circular(24),
                                            ),
                                          ),
                                          child: Center(
                                            child: SizedBox(
                                              height: 6,
                                              width: 36,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      widget.ibadahTheme.border,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: ColoredBox(
                                          color: widget
                                              .ibadahTheme.foregroundOnPrimary,
                                          child: DistrictSelectionBottomSheet(
                                            ibadahTheme: widget.ibadahTheme,
                                            searchHintText: finalStrings.searchHintText,
                                            onSelect: (district) {
                                              selectedDistrict.value = district;
                                              if (district != _ibadahBloc.selectedDistrict) {
                                                _ibadahBloc.add(
                                                  FetchSalatTime(
                                                    district: district,
                                                  ),
                                                );
                                              }
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 24,
                                        width: double.infinity,
                                        child: Container(
                                          color: widget
                                              .ibadahTheme.foregroundOnPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: .5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          right: 16,
                          left: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: widget.ibadahTheme.foregroundOnBackground,
                            ),
                            const SizedBox(width: 6),
                            ValueListenableBuilder(
                              valueListenable: selectedDistrict,
                              builder: (_, district, __) {
                                return Text(
                                  district,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),
            ValueListenableBuilder(
              valueListenable: salatTimeEntity,
              builder: (_, timeTable, __) {
                return Center(
                  child: NextPrayerWidget(
                    salatTimes: timeTable,
                    ibadahTheme: widget.ibadahTheme,
                    ibadahStrings: widget.ibadahStrings,
                    supportedLocals: widget.supportedLocals,
                    currentLocale: widget.currentLocale,
                  ),
                );
              },
            ),
            const Divider(height: 20),
            ValueListenableBuilder(
              valueListenable: salatTimeEntity,
              builder: (_, timeTable, __) {
                return ValueListenableBuilder(
                  valueListenable: periodicRefresh,
                  builder: (_, __, ___) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8,
                        left: 8,
                        right: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          SalahTimeWidget(
                            key: ValueKey(finalStrings.fajr),
                            ibadahTheme: widget.ibadahTheme,
                            currentLocale: widget.currentLocale,
                            iconPath: 'assets/icons/ic_sunrise.svg',
                            title: finalStrings.fajr,
                            startTime: timeTable.fajr,
                            supportedLocals: widget.supportedLocals,
                            ibadahStrings: widget.ibadahStrings,
                          ),
                          SalahTimeWidget(
                            key: ValueKey(finalStrings.dhuhr),
                            ibadahTheme: widget.ibadahTheme,
                            currentLocale: widget.currentLocale,
                            iconPath: 'assets/icons/ic_noon.svg',
                            title: finalStrings.dhuhr,
                            startTime: timeTable.dhuhr,
                            supportedLocals: widget.supportedLocals,
                            ibadahStrings: widget.ibadahStrings,
                          ),
                          SalahTimeWidget(
                            key: ValueKey(finalStrings.asr),
                            ibadahTheme: widget.ibadahTheme,
                            currentLocale: widget.currentLocale,
                            iconPath: 'assets/icons/ic_noon.svg',
                            title: finalStrings.asr,
                            startTime: timeTable.asr,
                            supportedLocals: widget.supportedLocals,
                            ibadahStrings: widget.ibadahStrings,
                          ),
                          SalahTimeWidget(
                            key: ValueKey(finalStrings.maghrib),
                            ibadahTheme: widget.ibadahTheme,
                            currentLocale: widget.currentLocale,
                            supportedLocals: widget.supportedLocals,
                            ibadahStrings: widget.ibadahStrings,
                            iconPath: 'assets/icons/ic_sunset.svg',
                            title: finalStrings.maghrib,
                            startTime: timeTable.maghrib,
                          ),
                          SalahTimeWidget(
                            key: ValueKey(finalStrings.isha),
                            ibadahTheme: widget.ibadahTheme,
                            currentLocale: widget.currentLocale,
                            supportedLocals: widget.supportedLocals,
                            ibadahStrings: widget.ibadahStrings,
                            iconPath: 'assets/icons/ic_night.svg',
                            title: finalStrings.isha,
                            startTime: timeTable.isha,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            BlocListener(
              bloc: _ibadahBloc,
              listener: (_, state) {
                if (state is SalatTimeFetchSuccess) {
                  salatTimeEntity.value = state.salatTime;
                }
              },
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
