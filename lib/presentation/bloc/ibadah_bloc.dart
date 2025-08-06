import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ibadah_event.dart';

part 'ibadah_state.dart';

class IbadahBloc extends Bloc<IbadahEvent, IbadahState> {
  final IbadahUseCase useCase;

  IbadahBloc({required this.useCase}) : super(IbadahInitial()) {
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
