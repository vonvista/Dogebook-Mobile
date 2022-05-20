import 'package:flutter/material.dart';
import 'db_helper.dart';

import 'package:localstorage/localstorage.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import 'models/comment_model.dart';

import 'feed_page.dart';

class Comments extends StatefulWidget {
  const Comments({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  late Future<List<Comment>> comments;

  LocalStorage storage = LocalStorage('project');

  //comment controller
  final TextEditingController _commentController = TextEditingController();

  DBHelper db = DBHelper();

  @override
  void initState() {
    super.initState();
    comments = db.getComments(widget.id);
    print(widget.id);
  }

  //comment tile
  Widget _commentTile(String id, String name, String comment, String createdAt, String userId) {
    return ListTile(
      leading: ProfilePicture(
        name: name,
        radius: 25,
        fontsize: 21,
      ),
      title: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'at $createdAt',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      subtitle: Text(comment),
      //trailing delete button if user is the author
      trailing: storage.getItem('_id') == userId
          ? IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                //NOTE: add delete comment logic
              },
            )
          : null,
    );
  }

  //create expanding comment field that is maximum of 3 lines with submit button
  Widget _commentField() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Comment',
              ),
              maxLines: 3,
              controller: _commentController,
            ),
          ),
          //icon button to submit comment
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              //NOTE: add add comment logic
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
