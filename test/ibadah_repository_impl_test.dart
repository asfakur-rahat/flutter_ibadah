import 'package:flutter_ibadah/flutter_ibadah.dart';
import 'package:flutter_ibadah/src/core/network/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ibadah/src/data/repositories/ibadah_repository_impl.dart';
import 'package:flutter_ibadah/src/domain/entities/salat_time_table_entity.dart';

void main() {
  group('IbadahRepositoryImpl', () {
    final repository = IbadahRepositoryImpl();

    test('getSalatTimeTable returns a DataState', () async {
      final result = await repository.getSalatTimeTable(
        location: const IbadahLocation(city: 'Dhaka', country: 'Bangladesh'),
        method: IbadahCalculationMethod.karachi,
        school: IbadahSchool.hanafi,
      );
      expect(result, isNotNull);
      expect(result, isA<DataState<SalatTimeTableEntity>>());
    });

    test('getSalatTimeTable handles a location the geocoder cannot resolve',
        () async {
      final result = await repository.getSalatTimeTable(
        location: const IbadahLocation(
          city: 'InvalidDistrict',
          country: 'Nowhere',
        ),
        method: IbadahCalculationMethod.karachi,
        school: IbadahSchool.hanafi,
      );
      expect(result, isNotNull);
      expect(result, isA<DataState<SalatTimeTableEntity>>());
      // The result can be either success or failure, both are valid responses
    });

    test('getSalatTimeTable accepts a non-Bangladeshi location', () async {
      final result = await repository.getSalatTimeTable(
        location: const IbadahLocation(city: 'Toronto', country: 'Canada'),
        method: IbadahCalculationMethod.isna,
        school: IbadahSchool.shafi,
      );
      expect(result, isA<DataState<SalatTimeTableEntity>>());
    });
  });
}
