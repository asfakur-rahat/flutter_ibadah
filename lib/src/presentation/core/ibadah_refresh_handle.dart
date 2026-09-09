/// The hook an `IbadahWidget` hands to its `IbadahController` so the
/// controller can drive it without depending on widget internals.
///
/// Deliberately kept out of the package's public exports.
abstract class IbadahRefreshHandle {
  /// Re-fetches the timetable for the currently selected district.
  Future<void> refreshSalatTime();
}
