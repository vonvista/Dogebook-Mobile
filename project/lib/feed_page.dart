import 'package:flutter/material.dart';
import 'db_helper.dart';

import 'package:localstorage/localstorage.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import 'models/post_model.dart';
import 'models/user_model.dart';

class Feed extends StatefulWidget {
  const Feed({
    Key? key,
    this.userId = "",
    this.mode = "normal",
  }) : super(key: key);

  final String mode;
  final String userId;

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  //variable for post privacy
  String privacy = 'public';
  String viewPostsOf = 'public';

  DBHelper db = DBHelper();

  late Future<List<Post>> posts = Future.value([]);
  final LocalStorage storage = LocalStorage('project');

  int limit = 0;
  bool hasMorePost = true;

  //post controller
  final TextEditingController _postController = TextEditingController();
  final _postScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    limit = db.limit;
    fetchNextPosts();
    // db.getPublicPostsLim("628495b811dbd074a7d039e5");

    ///NOTE: This is replaced by a button due to complication with nested scroll view

    // _postScrollController.addListener(() {

    //   if (_postScrollController.position.pixels ==
    //       _postScrollController.position.maxScrollExtent) {
    //     //get more posts
    //     print("HERE");
    //     fetchNextPosts();
    //   }
    // });
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  void fetchNextPosts() async {
    //get length of future post
    int postLength = await posts.then((value) => value.length);

    String lastpostid;

    if (postLength > 0) {
      Post lastpost = await posts.then((value) => value.last);
      //get last post id
      lastpostid = lastpost.id;
    } else {
      lastpostid = "";
    }
    //return next posts
    dynamic newPosts;
    print("FETCH!");
    if (widget.mode == "normal") {
      newPosts = db.getPublicPostsLim(lastpostid);
    } else if (widget.mode == "widget") {
      newPosts = db.getUserPostsLim(widget.userId, lastpostid);
    }
    // dynamic newPosts = db.getPublicPostsLim(lastpostid);
    //append new posts and old posts
    int newPostsLength = await newPosts.then((value) => value.length);
    newPostsLength < limit ? hasMorePost = false : hasMorePost = true;
    print(hasMorePost);
    setState(() {
      posts = Future.wait([posts, newPosts as Future<List<Post>>]).then((value) => value.expand((x) => x).toList());
    });
  }

  //create button for add post
  Widget _postBar() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            //text and icon
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.add),
                Text('Add Post'),
              ],
            ),
            //on press placeholder
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _postDialog(mode: 'add');
                },
              );
            },
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  //create card widget for posts, with comments icon
  Widget _postCard(String id, String name, String time, String post, String postPrivacy, String userId) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                //man icon
                ProfilePicture(
                  name: name,
                  radius: 25,
                  fontsize: 21,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Row(children: [
                      Text(
                        time,
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        postPrivacy == 'public' ? Icons.public : Icons.people,
                        size: 12,
                      ),
                    ]),
                  ],
                ),
                //Expanded
                Expanded(
                  child: Container(),
                ),
                //show edit and delete buttons if user is the owner of the post
                if (userId == storage.getItem('_id'))
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {},
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 10),
            Text(post),
            Divider(height: 20),
            //button with icon on left for comments
            ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.comment),
                  SizedBox(width: 10),
                  Text('Comments'),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  //create list of posts using future builder
  Widget _postsList() {
    return FutureBuilder<List<Post>>(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //use notificationlistener to detect if scroll has reached end of list
          return ListView.builder(
            // controller: _postScrollController,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: snapshot.data!.length + 1,
            itemBuilder: (context, index) {
              if (index < snapshot.data!.length) {
                return _postCard(
                  snapshot.data![index].id,
                  snapshot.data![index].name,
                  snapshot.data![index].createdAt,
                  snapshot.data![index].content,
                  snapshot.data![index].privacy,
                  snapshot.data![index].userId,
                );
              } else {
                return Center(
                  child: hasMorePost
                      ? //created button to load more posts
                      ElevatedButton(
                          child: Text('Load More'),
                          onPressed: () {
                            fetchNextPosts();
                          },
                        )
                      : Text('No more posts'),
                );
              }
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container();
        // return Center(child: CircularProgressIndicator());
      },
    );
  }

  //FOR POST DIALOG
  //create dialog with multiline field and button for posting
  Widget _postDialog({required String mode, String id = ""}) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                Text(
                  mode == 'add' ? "Create Post" : "Edit Post",
                  style: TextStyle(fontSize: 14),
                ),
                //fill space
                Expanded(child: SizedBox()),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _postController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                //black border
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  child: Text('Post'),
                  onPressed: () {},
                ),
                //create dropdown menu with options public or friends
                SizedBox(width: 10),
                Expanded(child: SizedBox()),
                _postPrivacyDropdown(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _postPrivacyDropdown() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter dropDownState) {
        return DropdownButton<String>(
          value: privacy,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          //set onchange
          onChanged: (String? newValue) {
            dropDownState(() {
              privacy = newValue!;
            });
          },
          items: <String>['public', 'friends'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //scrollable list of posts
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(
        controller: _postScrollController,
        shrinkWrap: widget.mode == 'normal' ? false : true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          _postBar(),
          SizedBox(height: 10),
          //add list of posts
          _postsList(),
        ],
      ),
      color: Color.fromARGB(31, 187, 187, 187),
    );
  }
}
