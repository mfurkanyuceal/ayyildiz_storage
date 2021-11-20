import 'dart:async';
import 'dart:convert';
import 'package:ayyildiz_storage/src/models/ayyildiz_storage_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';

class AyyildizStorage {
  static Future<bool> init() {
    WidgetsFlutterBinding.ensureInitialized();
    return GetStorage("AyyildizStorage").initStorage;
  }

  final GetStorage _box = GetStorage("AyyildizStorage");

  AyyildizStorage();

  bool isExist(String key) {
    return _box.hasData(key);
  }

  void remove(String key) {
    _box.remove(key);
  }

  R? readModel<R, T>({required String key, required T parseModel}) {
    final cacheData = _box.read(key);
    if (cacheData == null) return null;
    final json = jsonDecode(cacheData);
    var cacheObject = AyyildizStorageModel.fromJson<R, T>(json, parseModel);
    return cacheObject.data;
  }

  Future<void> write(String key, dynamic data) async {
    var registerModel = AyyildizStorageModel(
      key: key,
      data: data,
    );
    final json = jsonEncode(registerModel.toJson());
    await _box.write(key, json);
  }

  Future<void> cleanStorage() async {
    await _box.erase();
  }
}
