import 'package:flutter_ibadah/src/core/network/data_state.dart';
import 'package:flutter_ibadah/src/core/network/dio_service.dart';
import 'package:flutter_ibadah/src/data/models/salat_time_table_model.dart';
import 'package:flutter_ibadah/src/data/utils/ibadah_links.dart';

import '../../core/utils/common_utils.dart';
import '../../presentation/core/ibadah_calculation.dart';
import '../../presentation/core/ibadah_location.dart';

class IbadahService {
  final DioService _dioService = DioService();

  Future<DataState<SalatTimeTableModel>> getSalatTimeTable({
    required IbadahLocation location,
    required IbadahCalculationMethod method,
    required IbadahSchool school,
    Duration? knownUtcOffset,
  }) async {
    // Ask for the date it is *in that city*. Without a previous response we
    // have no offset to work from, so the device's date seeds the first fetch;
    // every fetch after that uses the offset the API told us.
    final requestDate = knownUtcOffset == null
        ? DateTime.now()
        : CommonUtils.inZone(DateTime.now(), knownUtcOffset);

    return _dioService.callApiService(
      api: () => _dioService.get(
        url: IbadahLinks.instance.getSalatTimeUrl(
          date: CommonUtils.formatDateDefault(
            requestDate,
            pattern: "dd-MM-yyyy",
          ),
          location: location,
          method: method,
          school: school,
        ),
      ),
      responseToDataExtractor: (data) async {
        final weekday = data['data']['date']['gregorian']['weekday']['en'];
        return SalatTimeTableModel.fromJson(
          data['data']['timings'],
          weekday.toLowerCase() == 'friday',
        );
      },
    );
  }
}
