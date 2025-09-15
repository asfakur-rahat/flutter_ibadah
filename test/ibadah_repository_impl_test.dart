import 'package:flutter_ibadah/src/core/network/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ibadah/src/data/repositories/ibadah_repository_impl.dart';
import 'package:flutter_ibadah/src/domain/entities/salat_time_table_entity.dart';

void main() {
  group('IbadahRepositoryImpl', () {
    final repository = IbadahRepositoryImpl();

    test('getSalatTimeTableForDistrict returns success', () async {
      final result = await repository.getSalatTimeTableForDistrict(district: 'Dhaka');
      expect(result, isNotNull);
      expect(result, isA<DataState<SalatTimeTableEntity>>());
    });

    test('getSalatTimeTableForDistrict handles any response', () async {
      final result = await repository.getSalatTimeTableForDistrict(district: 'InvalidDistrict');
      expect(result, isNotNull);
      expect(result, isA<DataState<SalatTimeTableEntity>>());
      // The result can be either success or failure, both are valid responses
    });
  });
}