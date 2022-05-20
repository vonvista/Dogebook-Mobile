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

  //create future builder list of search results
  Widget _friendRequestsList() {
    return FutureBuilder<List<User>>(
      future: friendRequests,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return _friendReqTile(
                  snapshot.data![index].id,
                  snapshot.data![index].firstName,
                  snapshot.data![index].email,
                );
              },
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            );
          } else {
            return Container(
              padding: EdgeInsets.all(30),
              child: Center(
                child: Text('No friend requests :('),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _friendsList() {
    return FutureBuilder<List<User>>(
      future: friends,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return _friendTile(
                snapshot.data![index].id,
                snapshot.data![index].firstName,
                snapshot.data![index].email,
              );
            },
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
