import 'package:ayyildiz_storage/ayyildiz_storage.dart';
import 'package:example/src/modules/post/post_list_view.dart';
import 'package:flutter/material.dart';

void main() {
  AyyildizStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Ayyildiz Storage Example',
      home: PostListPage(),
    );
  }
}
