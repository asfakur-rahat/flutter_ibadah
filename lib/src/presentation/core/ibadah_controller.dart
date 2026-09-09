import 'dart:math' as math;

import 'package:flutter/foundation.dart';

/// The state of the most recent prayer-time fetch performed by an
/// [IbadahWidget].
enum IbadahFetchStatus {
  /// Nothing has been fetched yet.
  initial,

  /// A fetch is currently in flight.
  loading,

  /// The last fetch completed and the timetable is up to date.
  success,

  /// The last fetch failed. The widget will retry automatically.
  failure,
}

/// The backoff ladder used when a fetch fails, capped at five minutes.
const List<Duration> _retryDelays = [
  Duration(seconds: 15),
  Duration(seconds: 30),
  Duration(seconds: 60),
  Duration(seconds: 120),
  Duration(seconds: 300),
];

/// Returns how long to wait before retry number [attempt] (zero based).
///
/// Walks the 15s → 30s → 1m → 2m → 5m ladder and stays at five minutes for
/// every attempt beyond it, so a widget left open offline keeps polling and
/// recovers within five minutes of connectivity returning.
Duration ibadahRetryDelay(int attempt) {
  final index = math.max(0, math.min(attempt, _retryDelays.length - 1));
  return _retryDelays[index];
}

/// The hook an `IbadahWidget` hands to its [IbadahController] so the
/// controller can drive it without depending on widget internals.
///
/// Implemented by the widget's [State]; you should not need to implement or
/// use this yourself.
abstract class IbadahRefreshHandle {
  /// Re-fetches the timetable for the currently selected district.
  Future<void> refreshSalatTime();
}

/// A handle that lets the host application drive an [IbadahWidget].
///
/// Pass it to `IbadahWidget(controller: ...)` and keep a reference in your
/// own [State]. Call [refresh] to fetch prayer times on demand — from a
/// pull-to-refresh, an app-resume hook, or your own connectivity listener:
///
/// ```dart
/// final controller = IbadahController();
///
/// RefreshIndicator(
///   onRefresh: controller.refresh,
///   child: ListView(
///     children: [
///       IbadahWidget(
///         controller: controller,
///         ibadahTheme: IbadahTheme.light(),
///         currentLocale: 'en',
///       ),
///     ],
///   ),
/// );
/// ```
///
/// The controller is a [ChangeNotifier], so you can also listen to it to
/// react to [status], [errorMessage] or [lastUpdated] changes:
///
/// ```dart
/// ListenableBuilder(
///   listenable: controller,
///   builder: (context, _) => Text('${controller.status}'),
/// );
/// ```
///
/// Remember to `dispose()` the controller with your own [State].
class IbadahController extends ChangeNotifier {
  IbadahRefreshHandle? _handle;

  IbadahFetchStatus _status = IbadahFetchStatus.initial;
  String? _district;
  DateTime? _lastUpdated;
  String? _errorMessage;

  /// The state of the most recent fetch.
  IbadahFetchStatus get status => _status;

  /// The district the widget last fetched prayer times for.
  ///
  /// `null` until the first fetch is dispatched.
  String? get district => _district;

  /// When the timetable was last fetched successfully.
  ///
  /// `null` if no fetch has succeeded yet. Stays at the last successful
  /// fetch when a later fetch fails.
  DateTime? get lastUpdated => _lastUpdated;

  /// The failure message of the last fetch, or `null` if it did not fail.
  String? get errorMessage => _errorMessage;

  /// Whether this controller is attached to a mounted [IbadahWidget].
  ///
  /// [refresh] does nothing while this is `false`.
  bool get isAttached => _handle != null;

  /// Re-fetches the prayer timetable for the current district.
  ///
  /// The returned future completes once the fetch settles, whether it
  /// succeeded or failed, which makes it safe to `await` from a
  /// `RefreshIndicator`. Completes immediately if the controller is not
  /// attached to a mounted [IbadahWidget].
  Future<void> refresh() async {
    final handle = _handle;
    if (handle == null) return;
    await handle.refreshSalatTime();
  }

  /// Attaches this controller to an [IbadahWidget].
  ///
  /// Called automatically by [IbadahWidget] when it mounts. You should not
  /// call this directly.
  void attach(IbadahRefreshHandle handle) {
    assert(
      _handle == null,
      'This IbadahController is already attached to an IbadahWidget. A '
      'controller can only drive one IbadahWidget at a time.',
    );
    _handle = handle;
  }

  /// Detaches this controller from an [IbadahWidget].
  ///
  /// Called automatically by [IbadahWidget] when it is disposed. You should
  /// not call this directly.
  void detach(IbadahRefreshHandle handle) {
    if (identical(_handle, handle)) _handle = null;
  }

  /// Pushes the widget's latest fetch state into this controller.
  ///
  /// Called automatically by [IbadahWidget] as a fetch progresses. You should
  /// not call this directly.
  void sync({
    required IbadahFetchStatus status,
    String? district,
    DateTime? lastUpdated,
    String? errorMessage,
  }) {
    final changed = _status != status ||
        _district != district ||
        _lastUpdated != lastUpdated ||
        _errorMessage != errorMessage;
    _status = status;
    _district = district;
    _lastUpdated = lastUpdated;
    _errorMessage = errorMessage;
    if (changed) notifyListeners();
  }
}
