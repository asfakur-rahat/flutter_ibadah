import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ibadah/src/domain/use_cases/ibadah_use_case.dart';

import '../../core/local/hive_service.dart';
import '../../core/network/data_state.dart';
import '../../domain/entities/salat_time_table_entity.dart';
import '../core/ibadah_calculation.dart';
import '../core/ibadah_location.dart';

part 'ibadah_event.dart';

part 'ibadah_state.dart';

/// Cache key holding the encoded [IbadahLocation] the user last selected.
///
/// Superseded the pre-multi-country `"district"` key, which held a bare
/// Bangladeshi city name; see `IbadahWidget` for the migration.
const String kIbadahLocationKey = "ibadah_location_v1";

/// The cache key used before the package supported countries other than
/// Bangladesh. Read once, migrated, then deleted.
const String kLegacyDistrictKey = "district";

class IbadahBloc extends Bloc<IbadahEvent, IbadahState> {
  final IbadahUseCase useCase = IbadahUseCase();

  IbadahBloc() : super(IbadahInitial()) {
    on<FetchSalatTime>(onFetchSalatTime);
  }

  SalatTimeTableEntity storedTime = const SalatTimeTableEntity();

  /// The location of the most recent fetch. Set before the request goes out.
  IbadahLocation? selectedLocation;

  /// The key of the fetch currently in flight, if any.
  ///
  /// `on<FetchSalatTime>` uses bloc's default concurrent transformer, and
  /// `IbadahWidget` can dispatch from a retry timer, the date-rollover timer
  /// and `IbadahController.refresh()`. A duplicate request for the location
  /// already being fetched is dropped; a request for a *different* location —
  /// or the same city with a different method/school — still goes through, so
  /// switching location mid-fetch is never lost.
  FetchSalatTime? _inFlight;

  void onFetchSalatTime(
    FetchSalatTime event,
    Emitter<IbadahState> emit,
  ) async {
    if (_inFlight == event) return;
    _inFlight = event;
    try {
      emit(SalatTimeFetching());
      final isSameLocation = selectedLocation == event.location;
      selectedLocation = event.location;
      await HiveService.instance
          .storeData(kIbadahLocationKey, event.location.encode());
      final responseState = await useCase.getSalatTimeTable(
        location: event.location,
        method: event.method,
        school: event.school,
        // Only reuse the cached offset when it belongs to this same city.
        knownUtcOffset: isSameLocation && storedTime.utcOffset != Duration.zero
            ? storedTime.utcOffset
            : null,
      );

      if (responseState is DataSuccess && responseState.data != null) {
        storedTime = responseState.data!;
        emit(SalatTimeFetchSuccess(salatTime: responseState.data!));
      } else {
        emit(
          SalatTimeFetchFailed(
            message: responseState.message ?? "Unknown error occurred",
            failedAt: DateTime.now(),
            isLocationError:
                responseState.dioException?.response?.statusCode == 400,
          ),
        );
      }
    } finally {
      if (_inFlight == event) _inFlight = null;
    }
  }
}
