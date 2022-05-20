import 'package:flutter/material.dart';
import 'db_helper.dart';

import 'package:localstorage/localstorage.dart';

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
        // Text("Show posts of: "),
        // //create dropdown selector for viewing public or friends post
        // DropdownButton<String>(
        //   value: privacy,
        //   icon: Icon(Icons.arrow_drop_down),
        //   iconSize: 24,
        //   elevation: 16,
        //   style: TextStyle(color: Colors.deepPurple),
        //   underline: Container(
        //     height: 2,
        //     color: Colors.deepPurpleAccent,
        //   ),
        //   onChanged: (String? newValue) {
        //     setState(() {
        //       privacy = newValue!;
        //     });
        //   },
        //   //items with text and icon for public and friends
        //   items: <String>['public', 'friends']
        //       .map<DropdownMenuItem<String>>((String value) {
        //     return DropdownMenuItem<String>(
        //       value: value,
        //       child: Row(
        //         children: <Widget>[
        //           Icon(
        //             value == 'public' ? Icons.public : Icons.people,
        //             color: Colors.deepPurple,
        //           ),
        //           const SizedBox(width: 10),
        //           Text(value),
        //         ],
        //       ),
        //     );
        //   }).toList(),
        //),
      ],
    );
  }
}
