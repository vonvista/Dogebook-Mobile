import 'package:flutter/material.dart';
import 'db_helper.dart';

import 'models/user_model.dart';

import 'package:localstorage/localstorage.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //create search controller
  final TextEditingController _searchController = TextEditingController();

  late Future<List<User>> searchResults;

  DBHelper db = DBHelper();

  @override
  void initState() {
    super.initState();
  }

  //create search bar with submit button
  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                //rounded
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  //create list tile for search results
  Widget _userListTile(String id, String name, String username) {
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
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      subtitle: Text(username),
      onTap: () {
        //NOTE: Navigation to profile
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
