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

  //create list tile for search results
  Widget _friendReqTile(String id, String name, String username) {
    return ListTile(
      leading: Hero(
        tag: 'image_$id',
        child: const Icon(
          Icons.person,
          color: Colors.blue,
        ),
      ),
      title: Hero(
        tag: "text_$id",
        child: Material(
          color: Colors.transparent,
          child: Text(
            name,
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      subtitle: Text(username),
      //trailing accept and reject buttons
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              //NOTE: add accepting of requests
            },
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {},
          ),
        ],
      ),
      onTap:
          //navigate to profile page
          () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              userId: id,
            ),
          ),
        );
      },
    );
  }

  //create list tile for search results
  Widget _friendTile(String id, String name, String username) {
    return ListTile(
      leading: Hero(
        tag: 'image_$id',
        child: const Icon(
          Icons.person,
          color: Colors.blue,
        ),
      ),
      title: Hero(
        tag: "text_$id",
        child: Material(
          color: Colors.transparent,
          child: Text(
            name,
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      subtitle: Text(username),
      //trailing accept and reject buttons
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Remove friend text button
          ElevatedButton(
            child: Text('Remove friend'),
            onPressed: () {
              //NOTE: add remove friend handler
            },
          ),
        ],
      ),
      onTap:
          //navigate to profile page
          () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              userId: id,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
