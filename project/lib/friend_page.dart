import 'package:flutter/material.dart';
import 'db_helper.dart';

import 'package:localstorage/localstorage.dart';

import 'models/user_model.dart';
import 'models/post_model.dart';

import 'feed_page.dart';
import 'profile_page.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final LocalStorage storage = LocalStorage('project');

  late Future<List<User>> friends;
  late Future<List<User>> friendRequests;

  DBHelper db = DBHelper();

  @override
  void initState() {
    super.initState();
    friendRequests = db.getFriendRequests(id: storage.getItem('_id'));
    friends = db.getFriends(id: storage.getItem('_id'));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
