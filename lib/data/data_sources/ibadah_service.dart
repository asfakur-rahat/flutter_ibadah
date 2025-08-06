import 'package:guardian_app/core/network/remote/dio_service.dart';
import 'package:guardian_app/core/resources/data_state.dart';
import 'package:guardian_app/core/utils/common_utils.dart';
import 'package:guardian_app/features/ibadah/data/models/salat_time_table_model.dart';
import 'package:guardian_app/features/ibadah/data/utils/ibadah_links.dart';

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
