class IbadahLinks {
  static final _instance = IbadahLinks._();

  IbadahLinks._();

  static IbadahLinks get instance => _instance;

  final String baseUrl = "https://api.aladhan.com/v1";

  String getSalatTimeUrlByDistrict({
    required String date,
    required String district,
  }) => "$baseUrl/timingsByAddress/$date?address=$district,Bangladesh&iso8601=true&method=1&school=1";
}
//&timezonestring=UTC
// https://api.aladhan.com/v1/timingsByCity?city=Dhaka&country=Bangladesh&method=1&school=0&tune=0,2,0,1,1,0,0,2,0
//"$baseUrl/timingsByCity/$date?city=$district&country=Bangladesh&iso8601=true&method=1&school=0&tune=0,2,0,1,1,0,0,2,0"
