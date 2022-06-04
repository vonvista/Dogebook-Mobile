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
  int _selectedIndex = 0; //index of selected tab
  String id = "";

  AppColors colors = AppColors(); //app colors
  LocalStorage storage = LocalStorage('project'); //local storage

  /// @brief: initial state on mount
  @override
  void initState() {
    super.initState();
  }

  /// @brief: function on tab change
  ///
  /// @param index: index of selected tab
  ///
  /// @return: void
  void _onItemTapped(int index) {
    if (index == 2) {
      //this is the app icon, do not do anything
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  /// @brief: the build method is called by the flutter framework.
  ///
  /// @param: context The BuildContext for the widget.
  ///
  /// @return: a widget that displays the home page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //create bottom navigation bar with feed, search, icon, friends, and profile
      body: Center(
        child: <Widget>[
          const Feed(),
          const SearchPage(),
          const SizedBox(
            height: 20,
          ),
          const FriendPage(),
          const UserPage(),
        ].elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: const Key('navigationBar'),
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
