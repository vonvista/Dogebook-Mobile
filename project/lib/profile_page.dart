import 'package:flutter/material.dart';
import 'db_helper.dart';

import 'package:localstorage/localstorage.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import 'models/user_model.dart';
import 'models/post_model.dart';

import 'feed_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> user;

  DBHelper db = DBHelper();

  final LocalStorage storage = LocalStorage('project');

  @override
  void initState() {
    super.initState();
    user = db.getUser(id: widget.userId);
    print(storage.getItem('friends').contains(widget.userId));
  }

  void handleSendRequest() async {
    dynamic result = await db.sendFriendRequest(
      userId: widget.userId,
      friendId: storage.getItem('_id'),
    );

    if (result['err'] != null) {
      print(result['err']);
      //show snackbar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['err']),
          //set duration
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      print(result);
    }
  }

  //create edit profile button
  Widget _editProfileButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      //if profile is user, show edit profile button, else show add friend button

      child: widget.userId == storage.getItem('_id')
          ? ElevatedButton(
              child: Text('Edit Profile'),
              onPressed: () {
                print("Saem");
              },
            )
          : storage.getItem('friends').contains(widget.userId)
              ? ElevatedButton(
                  child: Text('Friends'),
                  onPressed: () {},
                )
              : ElevatedButton(
                  child: Text('Send friend request'),
                  onPressed: () {
                    handleSendRequest();
                  },
                ),
    );
  }

  //build profile page with user info
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: FutureBuilder<User>(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Hero(
                      tag: "image_${snapshot.data!.id}",
                      child: ProfilePicture(
                        name: snapshot.data!.firstName + ' ' + snapshot.data!.lastName,
                        radius: 31,
                        fontsize: 21,
                      ),
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: "text_${snapshot.data!.id}",
                      child: Material(
                        child: Text(
                          snapshot.data!.firstName + " " + snapshot.data!.lastName,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      snapshot.data!.email,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  _editProfileButton(),
                  Feed(mode: "widget", userId: widget.userId),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
