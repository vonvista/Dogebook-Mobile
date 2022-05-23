import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'comments_page.dart';
import 'colors.dart';

import 'package:localstorage/localstorage.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:transition/transition.dart';

import 'models/post_model.dart';

class Feed extends StatefulWidget {
  const Feed({
    Key? key,
    this.userId = "",
    this.mode = "normal",
  }) : super(key: key);

  final String
      mode; //mode can be normal (accessed from bottom nav) or widget (accessed from profile page)
  final String
      userId; //(for widget mode) id of user whose profile is being viewed

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String privacy = 'public'; //variable for post privacy

  AppColors colors = AppColors(); //app colors

  DBHelper db = DBHelper(); //helper for accessing database functions

  late Future<List<Post>> posts = Future.value([]); //list of posts
  final LocalStorage storage = LocalStorage('project'); //local storage

  int limit = 0; //limit for number of posts to load (init to zero)
  bool hasMorePost = true; //boolean for whether there are more posts to load

  //post controller
  final TextEditingController _postController = TextEditingController();
  final _postScrollController = ScrollController();

  /// @brief: initial state on mount
  @override
  void initState() {
    super.initState();
    limit = db.limit;
    fetchNextPosts();

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

  /// @brief: dispose method
  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  /// @brief: function to fetch next posts
  ///
  /// @return: void
  void fetchNextPosts() async {
    int postLength =
        await posts.then((value) => value.length); //get length of future post

    String lastpostid; //id of last post

    if (postLength > 0) {
      Post lastpost = await posts.then((value) => value.last);
      //get last post id
      lastpostid = lastpost.id;
    } else {
      lastpostid = "";
    }

    ///return next posts, if normal mode, get post of friends and public posts
    ///if widget mode get posts of user with id userId
    dynamic newPosts;
    if (widget.mode == "normal") {
      newPosts = db.getPublicPostsLim(lastpostid, storage.getItem("_id"));
    } else if (widget.mode == "widget") {
      newPosts =
          db.getUserPostsLim(storage.getItem("_id"), widget.userId, lastpostid);
    }

    //append new posts and old posts
    int newPostsLength = await newPosts.then((value) => value.length);
    newPostsLength < limit ? hasMorePost = false : hasMorePost = true;
    print(hasMorePost);
    setState(() {
      posts = Future.wait([posts, newPosts as Future<List<Post>>])
          .then((value) => value.expand((x) => x).toList());
    });
  }

  /// @brief: function to handle comment button press
  ///
  /// @return: void
  void _handleComments(String id) async {
    //go to comments page
    Navigator.push(
        context,
        Transition(
            child: Comments(id: id),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
  }

  /// @brief: create widget for post bar
  ///
  /// @return: post bar widget
  Widget _postBar() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: colors.deg2,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              //height
              minimumSize: const Size(0, 50),
            ),
            //text and icon
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.add),
                Text('Create Post'),
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
      ],
    );
  }

  /// @brief: create card widget for posts, with comments
  ///
  /// @return: post widget
  Widget _postCard(String id, String name, String time, String post,
      String postPrivacy, String userId) {
    return Card(
      margin: const EdgeInsets.all(5),
      //radius
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
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
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Row(children: [
                      Text(
                        time,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 5),
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
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _postController.text = post;
                          privacy = postPrivacy;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _postDialog(mode: 'edit', id: id);
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _handlePostDelete(id);
                        },
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),
            //justification on left
            Align(
              child: Text(
                post,
                style: const TextStyle(fontSize: 16),
              ),
              alignment: Alignment.centerLeft,
            ),
            const Divider(height: 20),
            //button with icon on left for comments
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                //transparent button
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
                onPrimary: Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.comment),
                  SizedBox(width: 10),
                  Text('Comments'),
                ],
              ),
              onPressed: () {
                _handleComments(id);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// @brief: create list of posts using future builder
  ///
  /// @return: listview of posts
  Widget _postsList() {
    return FutureBuilder<List<Post>>(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //use notificationlistener to detect if scroll has reached end of list
          return ListView.builder(
            // controller: _postScrollController,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text('Load More'),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_downward),
                            ],
                          ),
                          onPressed: () {
                            fetchNextPosts();
                          },
                        )
                      : const Text('No more posts'),
                );
              }
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container();
        // return Center(child: CircularProgressIndicator());
      },
    );
  }

  //FOR POST DIALOG
  /// @brief: create modal with multiline field and button for posting
  ///
  /// @return: modal for create/edit post
  Widget _postDialog({required String mode, String id = ""}) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                Text(
                  mode == 'add' ? "Create Post" : "Edit Post",
                  style: const TextStyle(fontSize: 14),
                ),
                //fill space
                const Expanded(child: SizedBox()),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _postController.clear();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _postController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                //black border
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  child: const Text('Post'),
                  onPressed: () {
                    if (mode == 'add') {
                      _handlePost();
                    } else {
                      _handlePostEdit(id);
                    }
                  },
                ),
                //create dropdown menu with options public or friends
                const SizedBox(width: 10),
                const Expanded(child: SizedBox()),
                _postPrivacyDropdown(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// @brief: create dropdown menu with options public or friends for modal window
  ///
  /// @return: dropdown menu
  Widget _postPrivacyDropdown() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter dropDownState) {
        return DropdownButton<String>(
          value: privacy,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
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
          items: <String>['public', 'friends']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      },
    );
  }

  /// @brief: function for handling post creation
  ///
  /// @return: void
  void _handlePost() async {
    //get post text
    final String post = _postController.text;
    //if post is empty
    if (post.isEmpty) {
      return;
    }

    dynamic result = await db.addPost(
      userId: storage.getItem('_id'),
      content: post,
      privacy: privacy,
    );

    if (result != null) {
      //go to home page
      Navigator.pop(context);
      _postController.text = '';

      Post newPost = Post(
        id: result['_id'],
        userId: result['userId']['_id'],
        name:
            result['userId']['firstName'] + " " + result['userId']['lastName'],
        content: result['content'],
        privacy: result['privacy'],
        createdAt: db.convertTime(result['createdAt']),
      );
      setState(() {
        //append result on first index of the future list
        posts = posts.then((value) => [newPost, ...value]);
      });
    }
  }

  /// @brief: function for handling post edit
  ///
  /// @param: id: post id of post to edit
  ///
  /// @return: void
  void _handlePostEdit(String id) async {
    //get post text

    //post to server
    dynamic result = await db.editPost(
      id: id,
      content: _postController.text,
      privacy: privacy,
    );

    if (result != null) {
      Navigator.pop(context);
      Post newPost = Post(
        id: result['_id'],
        userId: result['userId']['_id'],
        name:
            result['userId']['firstName'] + " " + result['userId']['lastName'],
        content: result['content'],
        privacy: result['privacy'],
        createdAt: db.convertTime(result['createdAt']),
      );

      setState(() {
        //update post with new post on the list of posts using post id
        Future.value(posts = posts.then((value) => value.map((post) {
              if (post.id == id) {
                return newPost;
              }
              return post;
            }).toList()));
      });
    }
  }

  /// @brief: function for handling post deletion
  ///
  /// @param: id: post id of post to delete
  ///
  /// @return: void
  void _handlePostDelete(String id) async {
    //post to server
    dynamic result = await db.deletePost(
      id: id,
    );
    if (result != null) {
      String deletedId = result['_id'];
      setState(() {
        Future.value(
          posts = posts.then(
            (value) => value.where((post) => post.id != deletedId).toList(),
          ),
        );
      });
    }
  }

  /// @brief: the build method is called by the flutter framework.
  ///
  /// @param: context The BuildContext for the widget.
  ///
  /// @return: a widget that displays the feed.
  @override
  Widget build(BuildContext context) {
    //scrollable list of posts
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          controller: _postScrollController,
          shrinkWrap: widget.mode == 'normal' ? false : true,
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            //hide post bar if userId is not current user
            (widget.mode == "widget" &&
                        widget.userId == storage.getItem('_id')) ||
                    widget.mode == "normal"
                ? Align(
                    child: _postBar(),
                  )
                : Container(),
            //add list of posts
            const SizedBox(height: 10),
            _postsList(),
          ],
        ),
      ),
      color: colors.deg5,
    );
  }
}
