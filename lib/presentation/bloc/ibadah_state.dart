part of 'ibadah_bloc.dart';

sealed class IbadahState extends Equatable {
  const IbadahState();
}

final class IbadahInitial extends IbadahState {
  @override
  List<Object> get props => [];
}

final class SalatTimeFetching extends IbadahState {
  @override
  List<Object?> get props => [];
}

final class SalatTimeFetchSuccess extends IbadahState {
  final SalatTimeTableEntity salatTime;

  const SalatTimeFetchSuccess({
    required this.salatTime,
  });

  @override
  List<Object?> get props => [salatTime];
}

final class SalatTimeFetchFailed extends IbadahState {
  @override
  List<Object?> get props => [];
}
