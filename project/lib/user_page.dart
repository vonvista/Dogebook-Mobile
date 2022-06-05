import 'package:flutter/material.dart';
import 'colors.dart';
import 'globals.dart' as globals;

import 'package:localstorage/localstorage.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import 'login_page.dart';
import 'profile_page.dart';
import 'userupdate/update_password.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final LocalStorage storage = LocalStorage('project'); //local storage

  bool rebuild =
      false; //var for rebuilding page (used as an object key to trigger rebuild)

  AppColors colors = AppColors(); //app colors

  /// @brief: initial state on mount
  @override
  void initState() {
    super.initState();
    print("ON USER PAGE");
  }

  /// @brief: create list tile for friends
  ///
  /// @param: id: id of user
  /// @param: name: name of user
  /// @param: email: email of user
  ///
  /// @return: list tile for friends
  Widget _userListTile(String id, String name, String email) {
    return ListTile(
      key: ObjectKey(rebuild),
      leading: Hero(
        tag: 'image_$id',
        child: ProfilePicture(
          name: name,
          radius: 31,
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
      onTap:
          //navigate to profile page
          () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              userId: id,
            ),
          ),
        );
        //refresh page
        setState(() {
          rebuild = !rebuild;
        });
      },
    );
  }

  /// @brief: the build method is called by the flutter framework.
  ///
  /// @param: context The BuildContext for the widget.
  ///
  /// @return: a widget that displays the user page.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        children: [
          globals.enableAnimation
              ? Lottie.asset(
                  'assets/lottie/moodydog.json',
                )
              : Container(),
          //text view profile
          const Center(
            child: Text(
              'View your profile',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          _userListTile(
            //get string from snapshot
            storage.getItem('_id'),
            "${storage.getItem("firstName")} ${storage.getItem("lastName")}",
            storage.getItem('email'),
          ),
          const Divider(height: 10),
          //build logout
          ElevatedButton(
            key: Key('profileUpdatePass'),
            child: const Text('Update Password'),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdatePassword(),
                ),
              );
            },
          ),
          ElevatedButton(
            key: Key('profileLogout'),
            child: const Text('Logout'),
            onPressed: () {
              storage.clear();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
