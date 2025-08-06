import 'package:flutter/foundation.dart';
import 'package:guardian_app/core/resources/data_state.dart';
import 'package:guardian_app/features/ibadah/data/data_sources/ibadah_service.dart';
import 'package:guardian_app/features/ibadah/domain/entities/salat_time_table_entity.dart';
import 'package:guardian_app/features/ibadah/domain/repositories/ibadah_repository.dart';

class IbadahRepositoryImpl implements IbadahRepository {
  final IbadahService _service = IbadahService();

  @override
  Future<DataState<SalatTimeTableEntity>> getSalatTimeTableForDistrict({
    required String district,
  }) async {
    try {
      final response = await _service.getSalatTimeTableForDistrict(
        district: district,
      );
      if (response is DataSuccess) {
        if (response.data != null) {
          return DataSuccess(response.data?.toEntity());
        }
      } else {
        return DataFailed(
          dioException: response.dioException,
          message: response.message,
        );
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return const DataFailed(message: "Unknown error occurred");
  }
}
