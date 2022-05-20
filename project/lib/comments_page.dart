import 'package:flutter/material.dart';
import 'db_helper.dart';

import 'package:localstorage/localstorage.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import 'models/comment_model.dart';

import 'feed_page.dart';

class Comments extends StatefulWidget {
  const Comments({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  late Future<List<Comment>> comments;

  LocalStorage storage = LocalStorage('project');

  //comment controller
  final TextEditingController _commentController = TextEditingController();

  DBHelper db = DBHelper();

  @override
  void initState() {
    super.initState();
    comments = db.getComments(widget.id);
    print(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
