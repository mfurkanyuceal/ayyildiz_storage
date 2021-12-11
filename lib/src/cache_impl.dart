import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'models/ayyildiz_cache_model.dart';

class AyyildizCache {
  static Future<bool> init() {
    WidgetsFlutterBinding.ensureInitialized();
    return GetStorage('AyyildizCache').initStorage;
  }

  final GetStorage _box = GetStorage("AyyildizCache");

  late Duration _cacheDuration;

  AyyildizCache({Duration? cacheDuration}) {
    _cacheDuration = cacheDuration ?? const Duration(days: 730); //0x7fffffffffffffff is int64 max value.
    cleanCache();
  }

  bool isExist(String key) {
    return _box.hasData(key);
  }

  void remove(String key) {
    _box.remove(key);
  }

  R? readModel<R, T>({required String key, required T parseModel, bool forceRead = false}) {
    final cacheData = _box.read(key);
    if (cacheData == null) return null;
    final json = jsonDecode(cacheData);
    var cacheObject = AyyildizCacheModel.fromJson<R, T>(json, parseModel);
    if (cacheObject.lastUsableTime.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch) {
      return forceRead ? cacheObject.data : null;
    }
    return cacheObject.data;
  }

  Future<void> write(String key, dynamic data) async {
    var lastUsableTime = DateTime.now().add(_cacheDuration);
    var registerModel = AyyildizCacheModel(key: key, data: data, lastUsableTime: lastUsableTime);
    final json = jsonEncode(registerModel.toJson());
    await _box.write(key, json);
  }

  Future<void> cleanCache() async {
    await _box.erase();
  }
}
