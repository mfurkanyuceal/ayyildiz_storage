import 'dart:convert';
import 'ayyildiz_base_model.dart';

class AyyildizCacheModel {
  final String key;
  final dynamic data;
  final DateTime lastUsableTime;

  AyyildizCacheModel({required this.key, required this.data, required this.lastUsableTime});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'path': key,
        'data': jsonEncode(data),
        'lastUsableTime': lastUsableTime.toIso8601String(),
      };

  static AyyildizCacheModel fromJson<R, T>(Map<String, dynamic> json, dynamic parseModel) => AyyildizCacheModel(
        key: json['path'],
        data: _responseParser<R, T>(parseModel, jsonDecode(json['data'])),
        lastUsableTime: DateTime.parse(json['lastUsableTime']),
      );

  static R _responseParser<R, T>(AyyildizBaseModel model, dynamic data) {
    if (data is List) {
      return data.map((e) => model.fromJson(e)).toList().cast<T>() as R;
    } else if (data is Map<String, Object>) {
      return model.fromJson(data) as R;
    }
    return data as R;
  }
}
