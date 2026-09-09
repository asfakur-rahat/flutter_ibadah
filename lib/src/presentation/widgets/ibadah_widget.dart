import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ibadah/src/core/local/hive_service.dart';
import 'package:flutter_ibadah/src/core/utils/common_utils.dart';
import 'package:flutter_ibadah/src/core/utils/svg_color_mapper.dart';
import 'package:flutter_ibadah/src/domain/entities/salat_time_table_entity.dart';
import 'package:flutter_ibadah/src/presentation/bloc/ibadah_bloc.dart';
import 'package:flutter_ibadah/src/presentation/core/ibadah_controller.dart';
import 'package:flutter_ibadah/src/presentation/core/ibadah_strings.dart';
import 'package:flutter_ibadah/src/presentation/core/ibadah_theme.dart';
import 'package:flutter_ibadah/src/presentation/widgets/district_selection_bottom_sheet.dart';
import 'package:flutter_ibadah/src/presentation/widgets/salah_time_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';

import 'next_prayer_widget.dart';

export 'package:flutter_ibadah/src/presentation/core/ibadah_strings.dart';
export 'package:flutter_ibadah/src/presentation/core/ibadah_theme.dart';
export 'package:flutter_ibadah/src/presentation/core/ibadah_controller.dart';

class IbadahWidget extends StatefulWidget {
  IbadahWidget({
    super.key,
    required this.ibadahTheme,
    required this.currentLocale,
    this.supportedLocals = const ['en'],
    this.ibadahStrings = const [IbadahStrings()],
    this.useGradient = false,
    this.controller,
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
  final bool useGradient;

  /// An optional handle that lets the host application trigger a prayer-time
  /// refresh on demand and observe the fetch state.
  ///
  /// See [IbadahController]. The widget attaches to the controller while it
  /// is mounted and detaches on dispose; disposing the controller itself is
  /// the caller's responsibility.
  final IbadahController? controller;

  @override
  State<IbadahWidget> createState() => _IbadahWidgetState();
}

class _IbadahWidgetState extends State<IbadahWidget>
    with TickerProviderStateMixin
    implements IbadahRefreshHandle {
  //late Alerts _alerts;
  late Timer _timer;
  final IbadahBloc _ibadahBloc = IbadahBloc();
  final ValueNotifier<String> selectedDistrict = ValueNotifier("Dhaka");
  final ValueNotifier<SalatTimeTableEntity> salatTimeEntity = ValueNotifier(
    const SalatTimeTableEntity(),
  );
  final ValueNotifier<bool> periodicRefresh = ValueNotifier(true);
  final ValueNotifier<String> currentPrayer = ValueNotifier("Fajr");
  final ValueNotifier<IbadahFetchStatus> fetchStatus = ValueNotifier(
    IbadahFetchStatus.initial,
  );

  /// Backoff retry after a failed fetch, so the widget recovers on its own
  /// once connectivity returns instead of staying empty until restart.
  Timer? _retryTimer;
  int _retryAttempt = 0;

  /// One-shot timer that refetches just after midnight, so the timetable
  /// does not stay on yesterday's date.
  Timer? _midnightTimer;
  DateTime? _lastFetchedDay;

  /// Completed by the bloc listener once the in-flight fetch settles, so
  /// `IbadahController.refresh()` can be awaited.
  Completer<void>? _pendingFetch;

  String? _errorMessage;
  DateTime? _lastUpdated;

  @override
  void initState() {
    super.initState();
    CommonUtils.debugLog('Inside ibadah screen initstate');
    widget.controller?.attach(this);
    _initHive();
    _timer = Timer.periodic(const Duration(minutes: 30), (_) {
      periodicRefresh.value = !periodicRefresh.value;
      // Safety net for the midnight timer: if the day rolled over without a
      // refetch (timer drift, clock or timezone change), fetch now.
      if (_lastFetchedDay != null && !_isToday(_lastFetchedDay!)) {
        _fetchSalatTime(_ibadahBloc.selectedDistrict);
      }
    });
    _scheduleMidnightRefresh();
  }

  @override
  void didUpdateWidget(covariant IbadahWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.controller, widget.controller)) {
      oldWidget.controller?.detach(this);
      widget.controller?.attach(this);
      _syncController();
    }
  }

  void _initHive() async {
    await Hive.initFlutter();
    await HiveService.instance.init();
    if (!mounted) return;
    _initSalatTime();
  }

  void _initSalatTime() {
    String? district = HiveService.instance.retrieveData("district");
    selectedDistrict.value = district ?? "Dhaka";
    _fetchSalatTime(district ?? "Dhaka");
  }

  /// The single dispatch point for [FetchSalatTime].
  ///
  /// Returns a future that completes once the fetch settles, whether it
  /// succeeded or failed.
  Future<void> _fetchSalatTime(String district, {bool isRetry = false}) {
    _retryTimer?.cancel();
    _retryTimer = null;
    if (!isRetry) _retryAttempt = 0;

    final pending = _pendingFetch;
    if (pending != null && !pending.isCompleted) {
      if (district == _ibadahBloc.selectedDistrict) {
        // Same district already in flight; ride along rather than dispatching
        // a duplicate the bloc would drop anyway.
        return pending.future;
      }
      // Switching district mid-fetch: release the old waiter, the new fetch
      // supersedes it.
      _completePendingFetch();
    }

    final completer = Completer<void>();
    _pendingFetch = completer;
    _ibadahBloc.selectedDistrict = district;
    _ibadahBloc.add(FetchSalatTime(district: district));
    return completer.future;
  }

  @override
  Future<void> refreshSalatTime() =>
      _fetchSalatTime(_ibadahBloc.selectedDistrict);

  void _completePendingFetch() {
    final pending = _pendingFetch;
    _pendingFetch = null;
    if (pending != null && !pending.isCompleted) pending.complete();
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    final delay = ibadahRetryDelay(_retryAttempt);
    _retryAttempt++;
    _retryTimer = Timer(delay, () {
      if (!mounted) return;
      _fetchSalatTime(_ibadahBloc.selectedDistrict, isRetry: true);
    });
  }

  void _scheduleMidnightRefresh() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    // A minute past midnight, so the API is asked for the new date.
    final nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 1);
    _midnightTimer = Timer(nextMidnight.difference(now), () {
      if (!mounted) return;
      _fetchSalatTime(_ibadahBloc.selectedDistrict);
      _scheduleMidnightRefresh();
    });
  }

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  void _syncController() {
    widget.controller?.sync(
      status: fetchStatus.value,
      district: _ibadahBloc.selectedDistrict,
      lastUpdated: _lastUpdated,
      errorMessage: _errorMessage,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _retryTimer?.cancel();
    _midnightTimer?.cancel();
    _completePendingFetch();
    widget.controller?.detach(this);
    periodicRefresh.dispose();
    selectedDistrict.dispose();
    salatTimeEntity.dispose();
    currentPrayer.dispose();
    fetchStatus.dispose();
    super.dispose();
  }

  IbadahStrings get _strings => CommonUtils.getIbadahString(
        supportedLocals: widget.supportedLocals,
        ibadahStrings: widget.ibadahStrings,
        currentLocale: widget.currentLocale,
      );

  /// A spinner while a fetch is in flight and a retry button when the last
  /// one failed. Renders nothing otherwise, so the happy path is unchanged.
  Widget _buildRefreshIndicator() {
    return ValueListenableBuilder(
      valueListenable: fetchStatus,
      builder: (_, status, __) {
        if (status == IbadahFetchStatus.loading) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, right: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: widget.ibadahTheme.primaryColor,
                ),
              ),
            ),
          );
        }
        if (status != IbadahFetchStatus.failure) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 4, right: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _fetchSalatTime(_ibadahBloc.selectedDistrict),
              style: TextButton.styleFrom(
                foregroundColor: widget.ibadahTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(Icons.refresh, size: 16),
              label: Text(_strings.retry),
            ),
          ),
        );
      },
    );
  }

  /// Shown in place of the countdown when a fetch failed and there are no
  /// prayer times to fall back on.
  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Text(
          _errorMessage ?? _strings.somethingWentWrong,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: widget.ibadahTheme.foregroundOnBackground,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IbadahBloc>(
      create: (_) => _ibadahBloc,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient:
              widget.useGradient ? widget.ibadahTheme.backgroundGradient : null,
          color: widget.useGradient ? null : widget.ibadahTheme.backgroundColor,
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
                        CommonUtils.getIbadahString(
                          supportedLocals: widget.supportedLocals,
                          ibadahStrings: widget.ibadahStrings,
                          currentLocale: widget.currentLocale,
                        ).ibadah,
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
                                            searchHintText:
                                                CommonUtils.getIbadahString(
                                              supportedLocals:
                                                  widget.supportedLocals,
                                              ibadahStrings:
                                                  widget.ibadahStrings,
                                              currentLocale:
                                                  widget.currentLocale,
                                            ).searchHintText,
                                            onSelect: (district) {
                                              selectedDistrict.value = district;
                                              if (district !=
                                                  _ibadahBloc
                                                      .selectedDistrict) {
                                                _fetchSalatTime(district);
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
                          color: widget.ibadahTheme.border,
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
            _buildRefreshIndicator(),
            const Divider(height: 20),
            ValueListenableBuilder(
              valueListenable: fetchStatus,
              builder: (_, status, __) {
                return ValueListenableBuilder(
                  valueListenable: salatTimeEntity,
                  builder: (_, timeTable, __) {
                    // Only replace the countdown when the fetch failed and
                    // there is nothing to show; stale times stay visible and
                    // the header button offers the retry instead.
                    if (status == IbadahFetchStatus.failure &&
                        timeTable.fajr == null) {
                      return _buildErrorState();
                    }
                    return Center(
                      child: NextPrayerWidget(
                        salatTimes: timeTable,
                        ibadahTheme: widget.ibadahTheme,
                        ibadahStrings: widget.ibadahStrings,
                        supportedLocals: widget.supportedLocals,
                        currentLocale: widget.currentLocale,
                        getNextPrayerName: (prayerName) {
                          currentPrayer.value = prayerName;
                        },
                      ),
                    );
                  },
                );
              },
            ),
            const Divider(height: 20),
            ValueListenableBuilder(
                valueListenable: currentPrayer,
                builder: (_, currentPrayer, __) {
                  return ValueListenableBuilder(
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
                                  key: ValueKey(CommonUtils.getIbadahString(
                                        supportedLocals: widget.supportedLocals,
                                        ibadahStrings: widget.ibadahStrings,
                                        currentLocale: widget.currentLocale,
                                      ).fajr +
                                      widget.currentLocale),
                                  ibadahTheme: widget.ibadahTheme,
                                  currentLocale: widget.currentLocale,
                                  iconPath: 'assets/icons/ic_fajr.svg',
                                  title: CommonUtils.getIbadahString(
                                    supportedLocals: widget.supportedLocals,
                                    ibadahStrings: widget.ibadahStrings,
                                    currentLocale: widget.currentLocale,
                                  ).fajr,
                                  startTime: timeTable.fajr,
                                  supportedLocals: widget.supportedLocals,
                                  ibadahStrings: widget.ibadahStrings,
                                  currentPrayer: currentPrayer,
                                ),
                                SalahTimeWidget(
                                  key: ValueKey(CommonUtils.getIbadahString(
                                        supportedLocals: widget.supportedLocals,
                                        ibadahStrings: widget.ibadahStrings,
                                        currentLocale: widget.currentLocale,
                                      ).dhuhr +
                                      widget.currentLocale),
                                  ibadahTheme: widget.ibadahTheme,
                                  currentLocale: widget.currentLocale,
                                  iconPath: timeTable.isFriday
                                      ? 'assets/icons/ic_jummah.svg'
                                      : 'assets/icons/ic_duhr.svg',
                                  title: timeTable.isFriday
                                      ? CommonUtils.getIbadahString(
                                          supportedLocals:
                                              widget.supportedLocals,
                                          ibadahStrings: widget.ibadahStrings,
                                          currentLocale: widget.currentLocale,
                                        ).jummah
                                      : CommonUtils.getIbadahString(
                                          supportedLocals:
                                              widget.supportedLocals,
                                          ibadahStrings: widget.ibadahStrings,
                                          currentLocale: widget.currentLocale,
                                        ).dhuhr,
                                  startTime: timeTable.dhuhr,
                                  supportedLocals: widget.supportedLocals,
                                  ibadahStrings: widget.ibadahStrings,
                                  currentPrayer: currentPrayer,
                                ),
                                SalahTimeWidget(
                                  key: ValueKey(CommonUtils.getIbadahString(
                                        supportedLocals: widget.supportedLocals,
                                        ibadahStrings: widget.ibadahStrings,
                                        currentLocale: widget.currentLocale,
                                      ).asr +
                                      widget.currentLocale),
                                  ibadahTheme: widget.ibadahTheme,
                                  currentLocale: widget.currentLocale,
                                  iconPath: 'assets/icons/ic_asr.svg',
                                  title: CommonUtils.getIbadahString(
                                    supportedLocals: widget.supportedLocals,
                                    ibadahStrings: widget.ibadahStrings,
                                    currentLocale: widget.currentLocale,
                                  ).asr,
                                  startTime: timeTable.asr,
                                  supportedLocals: widget.supportedLocals,
                                  ibadahStrings: widget.ibadahStrings,
                                  currentPrayer: currentPrayer,
                                ),
                                SalahTimeWidget(
                                  key: ValueKey(CommonUtils.getIbadahString(
                                        supportedLocals: widget.supportedLocals,
                                        ibadahStrings: widget.ibadahStrings,
                                        currentLocale: widget.currentLocale,
                                      ).maghrib +
                                      widget.currentLocale),
                                  ibadahTheme: widget.ibadahTheme,
                                  currentLocale: widget.currentLocale,
                                  supportedLocals: widget.supportedLocals,
                                  ibadahStrings: widget.ibadahStrings,
                                  iconPath: 'assets/icons/ic_maghrib.svg',
                                  title: CommonUtils.getIbadahString(
                                    supportedLocals: widget.supportedLocals,
                                    ibadahStrings: widget.ibadahStrings,
                                    currentLocale: widget.currentLocale,
                                  ).maghrib,
                                  startTime: timeTable.maghrib,
                                  currentPrayer: currentPrayer,
                                ),
                                SalahTimeWidget(
                                  key: ValueKey(CommonUtils.getIbadahString(
                                        supportedLocals: widget.supportedLocals,
                                        ibadahStrings: widget.ibadahStrings,
                                        currentLocale: widget.currentLocale,
                                      ).isha +
                                      widget.currentLocale),
                                  ibadahTheme: widget.ibadahTheme,
                                  currentLocale: widget.currentLocale,
                                  supportedLocals: widget.supportedLocals,
                                  ibadahStrings: widget.ibadahStrings,
                                  iconPath: 'assets/icons/ic_isha.svg',
                                  title: CommonUtils.getIbadahString(
                                    supportedLocals: widget.supportedLocals,
                                    ibadahStrings: widget.ibadahStrings,
                                    currentLocale: widget.currentLocale,
                                  ).isha,
                                  startTime: timeTable.isha,
                                  currentPrayer: currentPrayer,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
            BlocListener<IbadahBloc, IbadahState>(
              bloc: _ibadahBloc,
              listener: (_, state) {
                switch (state) {
                  case SalatTimeFetching():
                    fetchStatus.value = IbadahFetchStatus.loading;
                  case SalatTimeFetchSuccess():
                    salatTimeEntity.value = state.salatTime;
                    _lastFetchedDay = DateTime.now();
                    _lastUpdated = _lastFetchedDay;
                    _errorMessage = null;
                    _retryAttempt = 0;
                    _retryTimer?.cancel();
                    _retryTimer = null;
                    fetchStatus.value = IbadahFetchStatus.success;
                    _completePendingFetch();
                  case SalatTimeFetchFailed():
                    // Keep any previously fetched times on screen.
                    _errorMessage = state.message;
                    fetchStatus.value = IbadahFetchStatus.failure;
                    _completePendingFetch();
                    _scheduleRetry();
                  case IbadahInitial():
                    break;
                }
                _syncController();
              },
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
