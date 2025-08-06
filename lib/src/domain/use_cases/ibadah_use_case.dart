import 'package:flutter_ibadah/src/core/network/data_state.dart';
import 'package:flutter_ibadah/src/data/repositories/ibadah_repository_impl.dart';
import 'package:flutter_ibadah/src/domain/entities/salat_time_table_entity.dart';

import '../repositories/ibadah_repository.dart';

class IbadahUseCase {
  final IbadahRepository repository =
      IbadahRepositoryImpl() as IbadahRepository;

  Future<DataState<SalatTimeTableEntity>> getSalatTimeTableForDistrict({
    required String district,
  }) async {
    return await repository.getSalatTimeTableForDistrict(district: district);
  }
}
