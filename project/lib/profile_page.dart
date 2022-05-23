import 'package:flutter/material.dart';
import 'db_helper.dart';

import 'colors.dart';

import 'package:localstorage/localstorage.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import 'models/user_model.dart';

import 'feed_page.dart';
import 'userupdate/update_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId; //id of user whose profile is being viewed

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> user; //user whose profile is being viewed

  bool rebuild =
      false; //var for rebuilding page (used as an object key to trigger rebuild)

  DBHelper db = DBHelper(); //helper for accessing database functions

  final LocalStorage storage = LocalStorage('project'); //local storage

  AppColors colors = AppColors(); //app colors

  /// @brief: initial state on mount
  @override
  void initState() {
    super.initState();
    user = db.getUser(id: widget.userId);
    // print(storage.getItem('friends').contains(widget.userId));
  }

  /// @brief: function for handling sending friend request
  ///
  /// @return: void
  void handleSendRequest() async {
    dynamic result = await db.sendFriendRequest(
      userId: widget.userId,
      friendId: storage.getItem('_id'),
    );

    if (result != null) {
      print("SUCCESS");
    }
  }

  /// @brief: function for handling update user button press
  ///
  /// @return: void
  void _handleUpdateUser() async {
    //got to user update page
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UpdateUser(),
      ),
    );
    //refresh the page
    setState(() {
      user = db.getUser(id: widget.userId);
      rebuild = !rebuild;
    });
  }

  /// @brief: create edit profile button
  ///
  /// @return: profile button widget
  Widget _editProfileButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      //if profile is user, show edit profile button, else show add friend button
      child: widget.userId == storage.getItem('_id')
          ? ElevatedButton(
              child: const Text('Edit Profile'),
              onPressed: () {
                _handleUpdateUser();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: colors.deg2,
                minimumSize: const Size.fromHeight(40),
              ),
            )
          : storage.getItem('friends').contains(widget.userId)
              ? ElevatedButton(
                  child: const Text('Friends'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: colors.deg2,
                    minimumSize: const Size.fromHeight(40),
                  ),
                )
              : ElevatedButton(
                  child: const Text('Send friend request'),
                  onPressed: () {
                    handleSendRequest();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: colors.deg2,
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
    );
  }

  /// @brief: the build method is called by the flutter framework.
  ///
  /// @param: context The BuildContext for the widget.
  ///
  /// @return: a widget that displays the profile page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        foregroundColor: Colors.white,
        backgroundColor: colors.deg1,
      ),
      body: Center(
        child: FutureBuilder<User>(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  Container(
                    color: colors.deg2,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Hero(
                            tag: "image_${snapshot.data!.id}",
                            //add white border to profile picture
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                color: Colors.white,
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                child: ProfilePicture(
                                  name: snapshot.data!.firstName +
                                      ' ' +
                                      snapshot.data!.lastName,
                                  radius: 31,
                                  fontsize: 21,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Hero(
                            tag: "text_${snapshot.data!.id}",
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                snapshot.data!.firstName +
                                    " " +
                                    snapshot.data!.lastName,
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            snapshot.data!.email,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        _editProfileButton(),
                      ],
                    ),
                  ),
                  Feed(
                      mode: "widget",
                      userId: widget.userId,
                      key: ObjectKey(rebuild)),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      backgroundColor: colors.deg5,
    );
  }
}
