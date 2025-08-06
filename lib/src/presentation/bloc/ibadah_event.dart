part of 'ibadah_bloc.dart';

sealed class IbadahEvent extends Equatable {
  const IbadahEvent();
}

class FetchSalatTime extends IbadahEvent {
  final String district;

  const FetchSalatTime({
    required this.district,
  });

  @override
  List<Object?> get props => [district];
}
