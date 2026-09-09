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
  const SalatTimeFetchFailed({
    required this.message,
    required this.failedAt,
  });

  /// Why the fetch failed, as reported by the network layer.
  final String message;

  /// When the failure happened.
  ///
  /// Part of [props] on purpose: without it two consecutive failures compare
  /// equal and bloc would not re-emit the second one, which would stall the
  /// automatic retry loop in `IbadahWidget`.
  final DateTime failedAt;

  @override
  List<Object?> get props => [message, failedAt];
}
