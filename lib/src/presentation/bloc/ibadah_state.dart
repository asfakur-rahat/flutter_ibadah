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
    this.isLocationError = false,
  });

  /// Why the fetch failed, as reported by the network layer.
  final String message;

  /// When the failure happened.
  ///
  /// Part of [props] on purpose: without it two consecutive failures compare
  /// equal and bloc would not re-emit the second one, which would stall the
  /// automatic retry loop in `IbadahWidget`.
  final DateTime failedAt;

  /// Whether the API rejected the location itself rather than failing for a
  /// transport reason — an unresolvable city/country pair comes back as a 400.
  ///
  /// The widget shows a location-specific message for these, since retrying
  /// the same address will never succeed.
  final bool isLocationError;

  @override
  List<Object?> get props => [message, failedAt, isLocationError];
}
