import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ibadah/src/core/local/hive_service.dart';
import 'package:flutter_ibadah/src/core/utils/common_utils.dart';
import 'package:flutter_ibadah/src/domain/entities/salat_time_table_entity.dart';
import 'package:flutter_ibadah/src/presentation/bloc/ibadah_bloc.dart';
import 'package:flutter_ibadah/src/presentation/core/ibadah_theme.dart';
import 'package:flutter_ibadah/src/presentation/widgets/district_selection_bottom_sheet.dart';
import 'package:flutter_ibadah/src/presentation/widgets/salah_time_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';

import 'next_prayer_widget.dart';

export 'package:flutter_ibadah/src/presentation/core/ibadah_theme.dart';

class IbadahScreen extends StatefulWidget {
  const IbadahScreen({super.key, required this.ibadahTheme});

  final IbadahTheme ibadahTheme;

  @override
  State<IbadahScreen> createState() => _IbadahScreenState();
}

class _IbadahScreenState extends State<IbadahScreen>
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
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Ibadah",
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
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 36,
                                      width: MediaQuery.sizeOf(context).width,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: widget
                                              .ibadahTheme.foregroundOnPrimary,
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
                                          onSelect: (district) {
                                            selectedDistrict.value = district;
                                            if (district !=
                                                _ibadahBloc.selectedDistrict) {
                                              _ibadahBloc.add(
                                                FetchSalatTime(
                                                    district: district),
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
                              color: Theme.of(context).colorScheme.onSurface,
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
                            key: const ValueKey("fajr"),
                            ibadahTheme: widget.ibadahTheme,
                            iconPath: 'assets/icons/ic_sunrise.svg',
                            title: "Fajr",
                            startTime: timeTable.fajr,
                          ),
                          SalahTimeWidget(
                            key: const ValueKey("dhuhr"),
                            ibadahTheme: widget.ibadahTheme,
                            iconPath: 'assets/icons/ic_noon.svg',
                            title: "Dhuhr",
                            startTime: timeTable.dhuhr,
                          ),
                          SalahTimeWidget(
                            key: const ValueKey("asr"),
                            ibadahTheme: widget.ibadahTheme,
                            iconPath: 'assets/icons/ic_noon.svg',
                            title: "Asr",
                            startTime: timeTable.asr,
                          ),
                          SalahTimeWidget(
                            key: const ValueKey("maghrib"),
                            ibadahTheme: widget.ibadahTheme,
                            iconPath: 'assets/icons/ic_sunset.svg',
                            title: "Maghrib",
                            startTime: timeTable.maghrib,
                          ),
                          SalahTimeWidget(
                            key: const ValueKey("isha"),
                            ibadahTheme: widget.ibadahTheme,
                            iconPath: 'assets/icons/ic_night.svg',
                            title: "Isha",
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
