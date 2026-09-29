part of 'ibadah_bloc.dart';

sealed class IbadahEvent extends Equatable {
  const IbadahEvent();
}

class FetchSalatTime extends IbadahEvent {
  final IbadahLocation location;
  final IbadahCalculationMethod method;
  final IbadahSchool school;

  const FetchSalatTime({
    required this.location,
    required this.method,
    required this.school,
  });

  @override
  List<Object?> get props => [location, method, school];
}
