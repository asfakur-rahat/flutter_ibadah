import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

class HiveService {
  static final HiveService _instance = HiveService._();

  /// Null until [init] has completed successfully.
  ///
  /// Every accessor below tolerates that, because the location cache is a
  /// convenience: if the box cannot be opened — a platform without a writable
  /// documents directory, a corrupt file, a widget test that never calls
  /// [init] — the widget must still fetch and display prayer times rather than
  /// throw on the way to the network.
  Box? _cacheBox;

  HiveService._();

  static HiveService get instance => _instance;

  /// Whether the cache box is open and usable.
  bool get isReady => _cacheBox != null;

  Future<void> init() async {
    if (_cacheBox != null) return;
    try {
      _cacheBox = await Hive.openBox("cacheBox");
    } catch (e, s) {
      debugPrint('HiveService.init failed, caching disabled: $e');
      debugPrint(s.toString());
    }
  }

  Future<void> storeData(String key, dynamic value) async {
    try {
      await _cacheBox?.put(key, value);
    } catch (e) {
      debugPrint('HiveService.storeData($key) failed: $e');
    }
  }

  dynamic retrieveData(String key) {
    try {
      return _cacheBox?.get(key);
    } catch (e) {
      debugPrint('HiveService.retrieveData($key) failed: $e');
      return null;
    }
  }

  Future<void> deleteCacheByKey(String key) async {
    try {
      await _cacheBox?.delete(key);
    } catch (e) {
      debugPrint('HiveService.deleteCacheByKey($key) failed: $e');
    }
  }

  Future<void> resetCache() async {
    await _cacheBox?.clear();
  }

  Future<void> deleteBox() async {
    await _cacheBox?.close();
    _cacheBox = null;
  }
}
