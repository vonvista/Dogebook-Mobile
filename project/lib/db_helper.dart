import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'models/user_model.dart';
import 'models/post_model.dart';
import 'package:intl/intl.dart';

import 'package:localstorage/localstorage.dart';

class DBHelper {
  final LocalStorage storage = LocalStorage('project');

  final String serverIP = "10.0.0.61";

  final int limit = 10;

  String convertTime(String time) {
    //convert ISO time to date and time format
    DateTime dateTime = DateTime.parse(time);
    //return date in format: hh:mm, June 1, 2020
    //DateFormat('MMMM').format(DateTime(0, month))
    return DateFormat('hh:mm a, MMMM d, yyyy').format(dateTime);
  }

  Future userLogin(Object user) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/user/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user),
    );

    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to load internet data');
    }
  }

  Future addUser(User user) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/user/add'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "firstName": user.firstName,
          "lastName": user.lastName,
          "email": user.email,
          "password": user.password,
          "friends": user.friends,
          "friendRequests": user.friendRequests
        },
      ),
    );

    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      if (data["err"] != null) {
        //print(data["err"]);
      } else {
        //print("successful");
      }
    } else {
      throw Exception('Failed to load internet data');
    }
  }

  Future<List<Post>> getPublicPostsLim(String postId) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/post/get-public-all-lim'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "limit": 10,
          "postId": postId,
        },
      ),
    );
    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      //print(data);
      List<Post> posts = [];
      for (var t in data) {
        posts.add(
          Post(
            id: t['_id'],
            userId: t['userId']['_id'],
            name: t['userId']['firstName'] + " " + t['userId']['lastName'],
            content: t['content'],
            privacy: t['privacy'],
            createdAt: convertTime(t['createdAt']),
          ),
        );
        //print(t['_id']);
      }
      return posts;
    } else {
      throw Exception('Failed to load internet data');
    }
  }

  Future<List<Post>> getUserPostsLim(String id, String next) async {
    //print("AD" + id);
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/post/get-user-posts-lim'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "limit": 10,
          "id": id,
          "next": next,
        },
      ),
    );

    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      //print(data);
      List<Post> posts = [];
      for (var t in data) {
        posts.add(Post(
          id: t['_id'],
          userId: t['userId']['_id'],
          name: t['userId']['firstName'] + " " + t['userId']['lastName'],
          content: t['content'],
          privacy: t['privacy'],
          createdAt: convertTime(t['createdAt']),
        ));
      }
      return posts;
    } else {
      throw Exception('Failed to load internet data');
    }
  }
}
