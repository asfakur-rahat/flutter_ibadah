import '../../core/network/data_state.dart';
import '../entities/salat_time_table_entity.dart';

abstract class IbadahRepository {
  Future<DataState<SalatTimeTableEntity>> getSalatTimeTableForDistrict({
    required String district,
  });
}
