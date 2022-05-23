import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'colors.dart';

import 'package:localstorage/localstorage.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import 'models/comment_model.dart';

class Comments extends StatefulWidget {
  const Comments({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  late Future<List<Comment>> comments; //list of comments
  AppColors colors = AppColors(); //app colors

  LocalStorage storage = LocalStorage('project'); //local storage

  //comment controller
  final TextEditingController _commentController = TextEditingController();

  DBHelper db = DBHelper(); //helper for accessing database functions

  /// @brief: initial state on mount
  @override
  void initState() {
    super.initState();
    comments = db.getComments(widget.id);
    //print(widget.id);
  }

  /// @brief: function for handling add comment
  ///
  /// @return: void
  void _handleAddComment() async {
    final String comment = _commentController.text;
    //if post is empty
    if (comment.isEmpty) {
      return;
    }
    //post to server
    dynamic result = await db.addComment(
      comment: comment,
      userId: storage.getItem('_id'),
      postId: widget.id,
    );
    if (result != null) {
      Comment newComment = Comment(
        id: result['_id'],
        userId: result['userId']['_id'],
        name:
            result['userId']['firstName'] + " " + result['userId']['lastName'],
        comment: result['comment'],
        createdAt: db.convertTime(result['createdAt']),
      );

      setState(() {
        //append result on first index of the future list
        Future.value(
            comments = comments.then((value) => [...value, newComment]));
      });
    }
  }

  /// @brief: function for handling delete comment
  ///
  /// @param: id: id of comment to be deleted
  ///
  /// @return: void
  void _handleDeleteComment(String id) async {
    //post to server
    dynamic result = await db.deleteComment(
      commentId: id,
    );
    //set comments to exclude delete post by result
    if (result != null) {
      String deletedId = result['_id'];
      //remove comment from list with matching id
      setState(() {
        Future.value(
          comments = comments.then(
            (value) =>
                value.where((comment) => comment.id != deletedId).toList(),
          ),
        );
      });
    }
  }

  /// @brief: create tile for comment
  ///
  /// @param: id: id of comment
  /// @param: name: name of user
  /// @param: comment: comment
  /// @param: createdAt: time of comment
  /// @param: userId: id of user
  ///
  /// @return: list tile widget for comment
  Widget _commentTile(
      String id, String name, String comment, String createdAt, String userId) {
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'at $createdAt',
            style: const TextStyle(
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
              icon: const Icon(Icons.delete),
              onPressed: () {
                _handleDeleteComment(id);
              },
            )
          : null,
    );
  }

  /// @build: create expanding comment field that is maximum of 3 lines with submit button
  ///
  /// @return: widget for comment field
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
            icon: const Icon(Icons.send),
            onPressed: () {
              _handleAddComment();
            },
          ),
        ],
      ),
      color: Colors.white,
    );
  }

  /// @brief: create future list builder for comments
  ///
  /// @return: list view widget for comments
  Widget _commentList() {
    return Container(
      child: FutureBuilder<List<Comment>>(
        future: comments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return _commentTile(
                        snapshot.data![index].id,
                        snapshot.data![index].name,
                        snapshot.data![index].comment,
                        snapshot.data![index].createdAt,
                        snapshot.data![index].userId,
                      );
                    },
                  )
                : Container(
                    padding: const EdgeInsets.all(30),
                    child: const Align(
                      alignment: Alignment.topCenter,
                      child: Text('No comments yet'),
                    ),
                  );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  /// @brief: the build method is called by the flutter framework.
  ///
  /// @param: context The BuildContext for the widget.
  ///
  /// @return: a widget that displays the comments.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: colors.deg1,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            _commentField(),
            _commentList(),

            // SafeArea(
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: _commentField(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
