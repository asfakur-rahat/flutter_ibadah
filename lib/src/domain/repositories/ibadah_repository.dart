import '../../core/network/data_state.dart';
import '../../presentation/core/ibadah_calculation.dart';
import '../../presentation/core/ibadah_location.dart';
import '../entities/salat_time_table_entity.dart';

abstract class IbadahRepository {
  Future<DataState<SalatTimeTableEntity>> getSalatTimeTable({
    required IbadahLocation location,
    required IbadahCalculationMethod method,
    required IbadahSchool school,
    Duration? knownUtcOffset,
  });
}
