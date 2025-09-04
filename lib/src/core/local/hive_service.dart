import 'package:hive_flutter/adapters.dart';

class HiveService {
  static final HiveService _instance = HiveService._();

  late Box _cacheBox;

  HiveService._();

  static HiveService get instance => _instance;

  Future<void> init() async {
    _cacheBox = await Hive.openBox("cacheBox");
  }

  Future<void> storeData(String key, dynamic value) async {
    await _cacheBox.put(key, value);
  }

  dynamic retrieveData(String key) {
    return _cacheBox.get(key);
  }

  Future<void> deleteCacheByKey(
    String key,
  ) async {
    await _cacheBox.delete(key);
  }

  Future<void> resetCache() async {
    await _cacheBox.clear();
  }

  Future<void> deleteBox() async {
    await _cacheBox.close();
  }
}
