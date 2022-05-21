import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'colors.dart';

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
  AppColors colors = AppColors();

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
    if (result['err'] != null) {
      print(result['err']);
    } else {
      Comment newComment = Comment(
        id: result['_id'],
        userId: result['userId']['_id'],
        name: result['userId']['firstName'] + " " + result['userId']['lastName'],
        comment: result['comment'],
        createdAt: db.convertTime(result['createdAt']),
      );

      setState(() {
        //append result on first index of the future list
        Future.value(comments = comments.then((value) => [...value, newComment]));
      });
    }
  }

  void _handleDeleteComment(String id) async {
    //post to server
    dynamic result = await db.deleteComment(
      commentId: id,
    );
    //set comments to exclude delete post by result
    String deletedId = result['_id'];
    setState(() {
      Future.value(
        comments = comments.then(
          (value) => value.where((comment) => comment.id != deletedId).toList(),
        ),
      );
    });
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
                _handleDeleteComment(id);
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
              _handleAddComment();
            },
          ),
        ],
      ),
      color: Colors.white,
    );
  }

  //create comment list
  Widget _commentList() {
    return Container(
      child: FutureBuilder<List<Comment>>(
        future: comments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
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
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
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
