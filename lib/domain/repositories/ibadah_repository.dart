import 'package:guardian_app/core/resources/data_state.dart';
import 'package:guardian_app/features/ibadah/domain/entities/salat_time_table_entity.dart';

abstract class IbadahRepository {
  Future<DataState<SalatTimeTableEntity>> getSalatTimeTableForDistrict({
    required String district,
  });
}