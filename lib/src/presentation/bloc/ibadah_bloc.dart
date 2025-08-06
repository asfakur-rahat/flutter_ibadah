import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ibadah/src/domain/use_cases/ibadah_use_case.dart';

import '../../core/local/hive_service.dart';
import '../../core/network/data_state.dart';
import '../../domain/entities/salat_time_table_entity.dart';

part 'ibadah_event.dart';

part 'ibadah_state.dart';

class IbadahBloc extends Bloc<IbadahEvent, IbadahState> {
  final IbadahUseCase useCase = IbadahUseCase();

  IbadahBloc() : super(IbadahInitial()) {
    on<FetchSalatTime>(onFetchSalatTime);
  }

  SalatTimeTableEntity storedTime = const SalatTimeTableEntity();

  String selectedDistrict = "Dhaka";

  void onFetchSalatTime(
    FetchSalatTime event,
    Emitter<IbadahState> emit,
  ) async {
    emit(SalatTimeFetching());
    selectedDistrict = event.district;
    await HiveService.instance.storeData("district", event.district);
    final responseState = await useCase.getSalatTimeTableForDistrict(
      district: event.district,
    );

    if (responseState is DataSuccess && responseState.data != null) {
      storedTime = responseState.data!;
      emit(SalatTimeFetchSuccess(salatTime: responseState.data!));
    } else {
      emit(SalatTimeFetchFailed());
    }
  }
}
