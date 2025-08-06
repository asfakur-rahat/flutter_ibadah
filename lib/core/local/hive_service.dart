import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

class HiveService{
  static final HiveService _instance = HiveService._();

  late Box _cacheBox;
  late Box _authBox;
  late Box _syncBox;

  HiveService._();

  static HiveService get instance => _instance;

  Future<void> init() async{
    _cacheBox = await Hive.openBox("cacheBox");
    _authBox = await Hive.openBox("authBox");
    _syncBox = await Hive.openBox("syncBox");
    if(Platform.isIOS){
      bool? isFirstLaunch = retrieveData("isFirstLaunch") as bool?;
      log("isFirstLaunch: $isFirstLaunch");
      if(isFirstLaunch==null){
        await storeData("isFirstLaunch", true);
      }
    }
  }

  Future<void> storeData(String key, dynamic value) async{
    await _cacheBox.put(key, value);
  }

  dynamic retrieveData(String key) {
    return _cacheBox.get(key);
  }

  Future<void> deleteCacheByKey(String key,) async{
    await _cacheBox.delete(key);
  }

  Future<void> resetCache() async{
    await _cacheBox.clear();
  }

  Future<void> deleteBox() async{
    await _cacheBox.close();
  }


  ///Auth store

  Future<void> saveUserId(String userId) async{
    await _authBox.put("user_id", userId);
  }

  String? getSavedUserId(){
    try{
      if(_authBox.containsKey("user_id")){
        return _authBox.get("user_id");
      }
    }
    catch(e,s){
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return null;
  }

  Future<void> clearUserId()async{
    await _authBox.delete("user_id");
  }


  Future<void> saveUserInfo(Map userInfo) async{
    log("user info: $userInfo");
    await _authBox.put("user", userInfo);
  }

  String? getAccessToken(){
    try{
      if(_authBox.containsKey("user")){
        Map userInfo =  _authBox.get("user");
        return userInfo['access_token'];
      }
    }
    catch(e,s){
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return null;
  }

  String? getRefreshToken(){
    try{
      Map userInfo =  _authBox.get("user");
      return userInfo['refresh_token'];
    }
    catch(e,s){
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return null;
  }

  Map? getUserInfo(){
    return _authBox.get("user");
  }

  Future<void> clearTokens()async{
    await _authBox.delete('user');
  }

  ///Sync Store
  Future<void> storeSyncData(String key, dynamic value) async{
    await _syncBox.put(key, value);
  }

  dynamic retrieveSyncData(String key) {
    return _syncBox.get(key);
  }

  ///Language
  Future<void> saveLanguage(String languageCode) async{
    await _syncBox.put("language", languageCode);
  }

  String? getSavedLanguage(){
    return _syncBox.get("language");
  }

  ///Theme
  Future<void> saveTheme(bool darkModeVal) async{
    await _syncBox.put("dark_theme", darkModeVal);
  }

  bool? getTheme() {
    return _syncBox.get("dark_theme");
  }
}