import 'dart:convert';
import 'ayyildiz_base_model.dart';

class AyyildizStorageModel {
  final String key;
  final dynamic data;

  AyyildizStorageModel({required this.key, required this.data});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'path': key,
        'data': jsonEncode(data),
      };

  static AyyildizStorageModel fromJson<R, T>(Map<String, dynamic> json, dynamic parseModel) =>
      AyyildizStorageModel(key: json['path'], data: _responseParser<R, T>(parseModel, jsonDecode(json['data'])));

  static R _responseParser<R, T>(AyyildizBaseModel model, dynamic data) {
    if (data is List) {
      return data.map((e) => model.fromJson(e)).toList().cast<T>() as R;
    } else if (data is Map<String, dynamic>) {
      return model.fromJson(data) as R;
    }
    return data as R;
  }
}
