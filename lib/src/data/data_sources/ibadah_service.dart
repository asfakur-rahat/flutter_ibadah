import 'package:flutter_ibadah/src/core/network/data_state.dart';
import 'package:flutter_ibadah/src/core/network/dio_service.dart';
import 'package:flutter_ibadah/src/data/models/salat_time_table_model.dart';
import 'package:flutter_ibadah/src/data/utils/ibadah_links.dart';

import '../../core/utils/common_utils.dart';

class IbadahService {
  final DioService _dioService = DioService();

  Future<DataState<SalatTimeTableModel>> getSalatTimeTableForDistrict({
    required String district,
  }) async {
    return _dioService.callApiService(
      api: () => _dioService.get(
        url: IbadahLinks.instance.getSalatTimeUrlByDistrict(
          date: CommonUtils.formatDateDefault(
            DateTime.now(),
            pattern: "dd-MM-yyyy",
          ),
          district: district,
        ),
      ),
      responseToDataExtractor: (data) async {
        return SalatTimeTableModel.fromJson(data['data']['timings']);
      },
    );
  }
}
