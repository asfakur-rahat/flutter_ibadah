import 'package:flutter_ibadah/src/core/network/data_state.dart';
import 'package:flutter_ibadah/src/data/repositories/ibadah_repository_impl.dart';
import 'package:flutter_ibadah/src/domain/entities/salat_time_table_entity.dart';

import '../../presentation/core/ibadah_calculation.dart';
import '../../presentation/core/ibadah_location.dart';
import '../repositories/ibadah_repository.dart';

class IbadahUseCase {
  final IbadahRepository repository = IbadahRepositoryImpl();

  Future<DataState<SalatTimeTableEntity>> getSalatTimeTable({
    required IbadahLocation location,
    required IbadahCalculationMethod method,
    required IbadahSchool school,
    Duration? knownUtcOffset,
  }) async {
    return await repository.getSalatTimeTable(
      location: location,
      method: method,
      school: school,
      knownUtcOffset: knownUtcOffset,
    );
  }
}
