import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ibadah/src/core/local/hive_service.dart';
import 'package:flutter_ibadah/src/domain/entities/salat_time_table_entity.dart';
import 'package:flutter_ibadah/src/presentation/bloc/ibadah_bloc.dart';
import 'package:flutter_ibadah/src/presentation/widgets/salah_time_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'next_prayer_widget.dart';

class IbadahScreen extends StatefulWidget {
  const IbadahScreen({super.key});

  @override
  State<IbadahScreen> createState() => _IbadahScreenState();
}

class _IbadahScreenState extends State<IbadahScreen> {
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
    //_alerts = Alerts(context: context);
    _initSalatTime();
    _timer = Timer.periodic(const Duration(minutes: 30), (_) {
      periodicRefresh.value = !periodicRefresh.value;
    });
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
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      SvgPicture.asset("assets/icons/mosque.svg", height: 24),
                      const SizedBox(width: 8),
                      Text(
                        "Ibadah",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // _alerts.openBottomSheet(
                      //   isDismissible: false,
                      //   child: DistrictSelectionBottomSheet(
                      //     onSelect: (district) {
                      //       selectedDistrict.value = district;
                      //       if (district != _ibadahBloc.selectedDistrict) {
                      //         _ibadahBloc.add(
                      //           FetchSalatTime(district: district),
                      //         );
                      //       }
                      //       _alerts.dismissDialog();
                      //     },
                      //   ),
                      // );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
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
                return Center(child: NextPrayerWidget(salatTimes: timeTable));
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
                            iconPath: 'assets/icons/sunrise.svg',
                            title: "Fajr",
                            startTime: timeTable.fajr,
                          ),
                          SalahTimeWidget(
                            iconPath: 'assets/icons/noon.svg',
                            title: "Dhuhr",
                            startTime: timeTable.dhuhr,
                          ),
                          SalahTimeWidget(
                            iconPath: 'assets/icons/noon.svg',
                            title: "Asr",
                            startTime: timeTable.asr,
                          ),
                          SalahTimeWidget(
                            iconPath: 'assets/icons/sunset.svg',
                            title: "Maghrib",
                            startTime: timeTable.maghrib,
                          ),
                          SalahTimeWidget(
                            iconPath: 'assets/icons/night.svg',
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
