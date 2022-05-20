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
  DBHelper db = DBHelper();

  late Future<List<Post>> posts = Future.value([]);
  final LocalStorage storage = LocalStorage('project');

  @override
  Widget build(BuildContext context) {
    return Container();
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
            onPressed: () {},
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
}
