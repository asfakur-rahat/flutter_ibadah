import '../../presentation/core/ibadah_calculation.dart';
import '../../presentation/core/ibadah_location.dart';

class IbadahLinks {
  static final _instance = IbadahLinks._();

  IbadahLinks._();

  static IbadahLinks get instance => _instance;

  final String baseUrl = "https://api.aladhan.com/v1";

  /// Builds the timetable URL for [location] on [date] (`dd-MM-yyyy`).
  ///
  /// Query parameters are built through [Uri] rather than interpolated, so
  /// cities and countries containing spaces or apostrophes — "Cox's Bazar",
  /// "Saudi Arabia" — are escaped correctly.
  String getSalatTimeUrl({
    required String date,
    required IbadahLocation location,
    required IbadahCalculationMethod method,
    required IbadahSchool school,
  }) =>
      Uri.parse("$baseUrl/timingsByAddress/$date").replace(
        queryParameters: {
          'address': location.address,
          'iso8601': 'true',
          'method': '${method.id}',
          'school': '${school.id}',
        },
      ).toString();
}
