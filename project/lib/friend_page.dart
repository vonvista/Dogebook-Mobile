import 'package:flutter/material.dart';
import 'db_helper.dart';

import 'package:localstorage/localstorage.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import 'models/user_model.dart';

import 'profile_page.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final LocalStorage storage = LocalStorage('project'); //local storage

  late Future<List<User>> friends; //friends
  late Future<List<User>> friendRequests; //friend requests

  DBHelper db = DBHelper(); //helper for accessing database functions

  /// @brief: initial state on mount
  @override
  void initState() {
    super.initState();
    friendRequests = db.getFriendRequests(id: storage.getItem('_id'));
    friends = db.getFriends(id: storage.getItem('_id'));
  }

  /// @brief: function for handling accept friend request
  ///
  /// @param: id: id of user to be accepted
  ///
  /// @return: void
  void _handleAcceptRequest(String id) async {
    dynamic result = await db.acceptFriendRequest(
      userId: id,
      friendId: storage.getItem('_id'),
    );

    if (result != null) {
      setState(() {
        friends = Future.value(db.getFriends(id: storage.getItem('_id')));
        friendRequests =
            Future.value(db.getFriendRequests(id: storage.getItem('_id')));
      });
    }
  }

  /// @brief: function for handling reject friend request
  ///
  /// @param: id: id of user to be rejected
  ///
  /// @return: void
  void _handleRejectRequest(String id) async {
    dynamic result = await db.rejectFriendRequest(
      userId: id,
      friendId: await storage.getItem('_id'),
    );
    print(result);
    if (result != null) {
      setState(() {
        friends = Future.value(db.getFriends(id: storage.getItem('_id')));
        friendRequests =
            Future.value(db.getFriendRequests(id: storage.getItem('_id')));
      });
    }
  }

  /// @brief: function for handling unfriending
  ///
  /// @param: id: id of user to be unfriended
  ///
  /// @return: void
  void _handleRemoveFriend(String id) async {
    dynamic result = await db.removeFriend(
      userId: id,
      friendId: storage.getItem('_id'),
    );

    if (result != null) {
      setState(() {
        friends = Future.value(db.getFriends(id: storage.getItem('_id')));
        friendRequests =
            Future.value(db.getFriendRequests(id: storage.getItem('_id')));
      });
      //set friends in localstorage to the new list
      await storage.setItem('friends', await friends.then((value) => value));
    }
  }

  /// @brief: create list tile for friend requests
  ///
  /// @param: id: id of user
  /// @param: name: name of user
  /// @param: email: email of user
  ///
  /// @return: list tile for friend requests
  Widget _friendReqTile(String id, String name, String email) {
    return ListTile(
      leading: Hero(
        tag: 'image_$id',
        child: ProfilePicture(
          name: name,
          radius: 25,
          fontsize: 21,
        ),
      ),
      title: Hero(
        tag: "text_$id",
        child: Material(
          color: Colors.transparent,
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      subtitle: Text(email),
      //trailing accept and reject buttons
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _handleAcceptRequest(id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _handleRejectRequest(id);
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

  /// @brief: create list tile for friends
  ///
  /// @param: id: id of user
  /// @param: name: name of user
  /// @param: email: email of user
  ///
  /// @return: list tile for friends
  Widget _friendTile(String id, String name, String email) {
    return ListTile(
      leading: Hero(
        tag: 'image_$id',
        child: ProfilePicture(
          name: name,
          radius: 25,
          fontsize: 21,
        ),
      ),
      title: Hero(
        tag: "text_$id",
        child: Material(
          color: Colors.transparent,
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      subtitle: Text(email),
      //trailing accept and reject buttons
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Remove friend text button
          ElevatedButton(
            child: const Text('Remove friend'),
            onPressed: () {
              _handleRemoveFriend(id);
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

  /// @brief: create future builder list of friend requests
  ///
  /// @return: future builder list of friend requests
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
                  snapshot.data![index].firstName +
                      ' ' +
                      snapshot.data![index].lastName,
                  snapshot.data![index].email,
                );
              },
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(30),
              child: const Center(
                child: Text('No friend requests :('),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  /// @brief: create future builder list of friends
  ///
  /// @return: future builder list of friends
  Widget _friendsList() {
    return FutureBuilder<List<User>>(
      future: friends,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return _friendTile(
                  snapshot.data![index].id,
                  snapshot.data![index].firstName +
                      ' ' +
                      snapshot.data![index].lastName,
                  snapshot.data![index].email,
                );
              },
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(30),
              child: const Center(
                child: Text('No friends :('),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  /// @brief: the build method is called by the flutter framework.
  ///
  /// @param: context The BuildContext for the widget.
  ///
  /// @return: a widget that displays the friends page.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          const Text(
            'Friend Requests',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            height: 20,
          ),
          SizedBox(height: 5),
          _friendRequestsList(),
          const Text(
            'Friends',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            height: 20,
          ),
          SizedBox(height: 5),
          _friendsList(),
        ],
      ),
    );
  }
}
