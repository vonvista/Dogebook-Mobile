import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'colors.dart';

import 'package:localstorage/localstorage.dart';

import 'models/user_model.dart';
import 'models/post_model.dart';

import 'login_page.dart';
import 'profile_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final LocalStorage storage = LocalStorage('project');

  AppColors colors = AppColors();

  @override
  void initState() {
    super.initState();
  }

  //create list tile for user
  Widget _userListTile(String id, String name, String username) {
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
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        children: [
          //text view profile
          const Center(
            child: Text(
              '  View your profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          _userListTile(
            //get string from snapshot
            storage.getItem('_id'),
            "${storage.getItem("firstName")} ${storage.getItem("lastName")}",
            storage.getItem('email'),
          ),
          Divider(height: 10),
          //build logout
          Container(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                storage.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
