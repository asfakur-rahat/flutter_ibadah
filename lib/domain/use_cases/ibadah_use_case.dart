import 'package:guardian_app/core/resources/data_state.dart';
import 'package:guardian_app/features/ibadah/domain/entities/salat_time_table_entity.dart';
import 'package:guardian_app/features/ibadah/domain/repositories/ibadah_repository.dart';

class IbadahUseCase {
  final IbadahRepository repository;

  const IbadahUseCase(this.repository);

  Future<DataState<SalatTimeTableEntity>> getSalatTimeTableForDistrict({
    required String district,
  })async {
    return await repository.getSalatTimeTableForDistrict(district: district);
  }
}