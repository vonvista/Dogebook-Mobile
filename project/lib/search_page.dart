import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'colors.dart';

import 'models/user_model.dart';

import 'profile_page.dart';

import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //create search controller
  final TextEditingController _searchController = TextEditingController();

  AppColors colors = AppColors(); //app colors

  bool rebuild =
      false; //var for rebuilding page (used as an object key to trigger rebuild)

  late Future<List<User>> searchResults = Future.value([]); //search results

  DBHelper db = DBHelper(); //helper for accessing database functions

  /// @brief: initial state on mount
  @override
  void initState() {
    super.initState();
  }

  /// @brief: function to handle search
  ///
  /// @return: void
  void _handleSearch() async {
    final String search = _searchController.text;
    //if post is empty
    if (search.isEmpty) {
      return;
    }

    dynamic result = await db.findUser(
      username: search,
    );
    //set search results
    //NOTE: To be fixed, may duplicates parin sa search, fix in db
    setState(() {
      searchResults = Future.value(result);
    });
  }

  /// @brief: create search bar with submit button
  ///
  /// @return: search bar widget with submit button
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
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              //change size of text field
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              _handleSearch();
            },
          ),
        ],
      ),
      color: colors.deg2,
    );
  }

  /// @brief: create list tile for search results
  ///
  /// @param: id: id of user
  /// @param: name: name of user
  /// @param: email: email of user
  ///
  /// @return: list tile for search results
  Widget _userListTile(String id, String name, String email) {
    return ListTile(
      leading: Hero(
        tag: 'image_$id',
        child: Material(
          color: Colors.transparent,
          child: ProfilePicture(
            name: name,
            radius: 25,
            fontsize: 21,
          ),
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
        _handleSearch();
      },
    );
  }

  /// @brief: create future builder list of search results
  ///
  /// @return: future builder list view of search results
  Widget _searchResults() {
    return FutureBuilder<List<User>>(
      future: searchResults,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return _userListTile(
                snapshot.data![index].id,
                snapshot.data![index].firstName +
                    " " +
                    snapshot.data![index].lastName,
                snapshot.data![index].email,
              );
            },
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
          );
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
  /// @return: a widget that displays the search page.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            _searchBar(),
            _searchResults(),
          ],
        ),
      ),
    );
  }
}
