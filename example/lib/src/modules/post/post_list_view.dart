import 'dart:convert';
import 'dart:io';

import 'package:ayyildiz_storage/ayyildiz_storage.dart';
import 'package:example/src/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final _scaffoldKey = GlobalKey();

  final AyyildizStorage _ayyildizStorage = AyyildizStorage();

  List<PostModel> posts = <PostModel>[];
  bool isBusy = false;
  bool hasError = false;

  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(posts[index].title ?? "Title"),
        subtitle: Text(posts[index].body ?? "Body"),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Post List"),
        centerTitle: false,
        actions: [
          IconButton(onPressed: getPostList, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: removePostList, icon: const Icon(Icons.delete)),
          IconButton(onPressed: isExistPostList, icon: const Icon(Icons.query_stats)),
        ],
      ),
      body: isBusy
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(
                  child: Text("Error"),
                )
              : RefreshIndicator(
                  onRefresh: getPostList,
                  child: ListView.separated(
                      itemBuilder: (context, index) => _itemBuilder(context, index),
                      separatorBuilder: (context, index) => Container(width: 2, color: Colors.grey),
                      itemCount: posts.length),
                ),
    );
  }

  Future getPostList() async {
    setState(() {
      isBusy = true;
    });

    if (_ayyildizStorage.isExist("post_list")) {
      posts = _ayyildizStorage.readModel<List<PostModel>, PostModel>(key: "post_list", parseModel: PostModel())!;
      showSnackBarText("Post List data from  ayyildiz storage.");
    } else {
      posts = await postListRequest() ?? <PostModel>[];
    }

    setState(() {
      isBusy = false;
    });
  }

  bool isExistPostList() {
    var result = _ayyildizStorage.isExist("post_list");
    showSnackBarText(result ? "Post List is exist" : "Post List is not exist");
    return result;
  }

  void removePostList() {
    var result = _ayyildizStorage.isExist("post_list");
    if (result) {
      _ayyildizStorage.remove("post_list");
      showSnackBarText("Post List was erased");
    } else {
      showSnackBarText("Post List is not exist");
    }
  }

  Future<List<PostModel>?> postListRequest() async {
    var response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    if (response.statusCode == HttpStatus.ok) {
      var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      List<PostModel> list = List<PostModel>.from(decodedResponse.map((x) => PostModel.fromJson(x)));
      await _ayyildizStorage.write("post_list", list);

      showSnackBarText("Data From  URL, saved to ayyildiz storage");
      return list;
    }
    return null;
  }

  showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
