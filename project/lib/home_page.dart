import 'package:flutter/material.dart';

import 'models/user_model.dart';

import 'feed_page.dart';
import 'search_page.dart';
import 'user_page.dart';
import 'friend_page.dart';
import 'colors.dart';

import 'package:localstorage/localstorage.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String id = "";

  AppColors colors = AppColors();
  LocalStorage storage = LocalStorage('project');

  @override
  void initState() {
    super.initState();
  }

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    if (index == 2) {
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //create bottom navigation bar with feed, search, icon, friends, and profile
      body: Center(
        child: <Widget>[
          Feed(),
          SearchPage(),
          SizedBox(
            height: 20,
          ),
          FriendPage(),
          UserPage(),
        ].elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              //change color of icon when selected or not
              color: _selectedIndex == 0 ? Colors.white : colors.deg2dark,
            ),
            label: 'Feed',
            backgroundColor: colors.deg2,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              //change color of icon when selected or not
              color: _selectedIndex == 1 ? Colors.white : colors.deg2dark,
            ),
            label: 'Search',
            backgroundColor: colors.deg2,
          ),
          BottomNavigationBarItem(
            icon: //image of logo.png
                Image.asset(
              'assets/images/logo.png',
              width: 30,
              height: 30,
            ),
            label: 'Add',
            backgroundColor: colors.deg2,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
              //change color of icon when selected or not
              color: _selectedIndex == 3 ? Colors.white : colors.deg2dark,
            ),
            label: 'Friends',
            backgroundColor: colors.deg2,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              //change color of icon when selected or not
              color: _selectedIndex == 4 ? Colors.white : colors.deg2dark,
            ),
            label: 'Profile',
            backgroundColor: colors.deg2,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
