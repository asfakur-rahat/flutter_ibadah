import 'ibadah_location.dart';

/// The 64 administrative districts of Bangladesh.
///
/// This is the default value of `IbadahWidget.locations`, so a widget that does
/// not pass a location list behaves exactly as it did before the package
/// supported other countries.
///
/// Pass your own list — of any countries — to show somewhere else:
///
/// ```dart
/// IbadahWidget(
///   locations: const [
///     IbadahLocation(city: 'Dhaka', country: 'Bangladesh'),
///     IbadahLocation(city: 'Mecca', country: 'Saudi Arabia'),
///   ],
///   ...
/// )
/// ```
const List<IbadahLocation> bangladeshDistricts = [
  IbadahLocation(city: "Bagerhat", country: "Bangladesh"),
  IbadahLocation(city: "Bandarban", country: "Bangladesh"),
  IbadahLocation(city: "Barguna", country: "Bangladesh"),
  IbadahLocation(city: "Barisal", country: "Bangladesh"),
  IbadahLocation(city: "Bhola", country: "Bangladesh"),
  IbadahLocation(city: "Bogura", country: "Bangladesh"),
  IbadahLocation(city: "Brahmanbaria", country: "Bangladesh"),
  IbadahLocation(city: "Chandpur", country: "Bangladesh"),
  IbadahLocation(city: "Chapai Nawabganj", country: "Bangladesh"),
  IbadahLocation(city: "Chattogram", country: "Bangladesh"),
  IbadahLocation(city: "Chuadanga", country: "Bangladesh"),
  IbadahLocation(city: "Cox's Bazar", country: "Bangladesh"),
  IbadahLocation(city: "Cumilla", country: "Bangladesh"),
  IbadahLocation(city: "Dhaka", country: "Bangladesh"),
  IbadahLocation(city: "Dinajpur", country: "Bangladesh"),
  IbadahLocation(city: "Faridpur", country: "Bangladesh"),
  IbadahLocation(city: "Feni", country: "Bangladesh"),
  IbadahLocation(city: "Gaibandha", country: "Bangladesh"),
  IbadahLocation(city: "Gazipur", country: "Bangladesh"),
  IbadahLocation(city: "Gopalganj", country: "Bangladesh"),
  IbadahLocation(city: "Habiganj", country: "Bangladesh"),
  IbadahLocation(city: "Jamalpur", country: "Bangladesh"),
  IbadahLocation(city: "Jashore", country: "Bangladesh"),
  IbadahLocation(city: "Jhalokathi", country: "Bangladesh"),
  IbadahLocation(city: "Jhenaidah", country: "Bangladesh"),
  IbadahLocation(city: "Joypurhat", country: "Bangladesh"),
  IbadahLocation(city: "Khagrachari", country: "Bangladesh"),
  IbadahLocation(city: "Khulna", country: "Bangladesh"),
  IbadahLocation(city: "Kishoreganj", country: "Bangladesh"),
  IbadahLocation(city: "Kurigram", country: "Bangladesh"),
  IbadahLocation(city: "Kushtia", country: "Bangladesh"),
  IbadahLocation(city: "Lakshmipur", country: "Bangladesh"),
  IbadahLocation(city: "Lalmonirhat", country: "Bangladesh"),
  IbadahLocation(city: "Madaripur", country: "Bangladesh"),
  IbadahLocation(city: "Magura", country: "Bangladesh"),
  IbadahLocation(city: "Manikganj", country: "Bangladesh"),
  IbadahLocation(city: "Meherpur", country: "Bangladesh"),
  IbadahLocation(city: "Moulvibazar", country: "Bangladesh"),
  IbadahLocation(city: "Munshiganj", country: "Bangladesh"),
  IbadahLocation(city: "Mymensingh", country: "Bangladesh"),
  IbadahLocation(city: "Naogaon", country: "Bangladesh"),
  IbadahLocation(city: "Narail", country: "Bangladesh"),
  IbadahLocation(city: "Narayanganj", country: "Bangladesh"),
  IbadahLocation(city: "Narsingdi", country: "Bangladesh"),
  IbadahLocation(city: "Natore", country: "Bangladesh"),
  IbadahLocation(city: "Netrokona", country: "Bangladesh"),
  IbadahLocation(city: "Nilphamari", country: "Bangladesh"),
  IbadahLocation(city: "Noakhali", country: "Bangladesh"),
  IbadahLocation(city: "Pabna", country: "Bangladesh"),
  IbadahLocation(city: "Panchagarh", country: "Bangladesh"),
  IbadahLocation(city: "Patuakhali", country: "Bangladesh"),
  IbadahLocation(city: "Pirojpur", country: "Bangladesh"),
  IbadahLocation(city: "Rajbari", country: "Bangladesh"),
  IbadahLocation(city: "Rajshahi", country: "Bangladesh"),
  IbadahLocation(city: "Rangamati", country: "Bangladesh"),
  IbadahLocation(city: "Rangpur", country: "Bangladesh"),
  IbadahLocation(city: "Satkhira", country: "Bangladesh"),
  IbadahLocation(city: "Shariatpur", country: "Bangladesh"),
  IbadahLocation(city: "Sherpur", country: "Bangladesh"),
  IbadahLocation(city: "Sirajganj", country: "Bangladesh"),
  IbadahLocation(city: "Sunamganj", country: "Bangladesh"),
  IbadahLocation(city: "Sylhet", country: "Bangladesh"),
  IbadahLocation(city: "Tangail", country: "Bangladesh"),
  IbadahLocation(city: "Thakurgaon", country: "Bangladesh"),
];

/// The location a widget falls back to when no `initialLocation` is given and
/// nothing is cached.
///
/// Kept as Dhaka — the default before the package supported other countries —
/// so an existing `IbadahWidget()` opens on the same city it always has, even
/// though [bangladeshDistricts] is sorted alphabetically.
const IbadahLocation kDefaultIbadahLocation = IbadahLocation(
  city: "Dhaka",
  country: "Bangladesh",
);
