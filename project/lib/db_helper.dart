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

  Future findUser({required String username}) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/user/search'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "username": username,
        },
      ),
    );
    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      //specify that data is json
      var data = (jsonDecode(response.body));

      List<User> users = [];
      for (var t in data) {
        users.add(User(
          id: t['_id'],
          firstName: t['firstName'],
          lastName: t['lastName'],
          email: t['email'],
          password: "", //hide password
          friends: t['friends'].cast<String>(), //cast to list of strings,
          friendRequests: t['friendRequests'].cast<String>(), // "as List<String> doesn't seem to work"
        ));
      }
      //if error message
      return users;
    } else {
      throw Exception('Failed to load internet data');
    }
  }

  Future<User> getUser({required String id}) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/user/find'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "id": id,
        },
      ),
    );
    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      //specify that data is json
      var data = (jsonDecode(response.body));
      return User(
        id: data['_id'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        email: data['email'],
        password: "", //hide password
        friends: data['friends'].cast<String>(), //cast to list of strings,
        friendRequests: data['friendRequests'].cast<String>(), // "as List<String> doesn't seem to work"
      );
    } else {
      throw Exception('Failed to load internet data');
    }
  }

  //FRIEND SYSTEM

  //send friend request
  Future sendFriendRequest({
    required String userId,
    required String friendId,
  }) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/user/send-friend-request'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "userId": userId,
          "friendId": friendId,
        },
      ),
    );
    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      //print(data);
      return data;
    } else {
      throw Exception('Failed to load internet data');
    }
  }

  //get friends requests
  Future<List<User>> getFriendRequests({required String id}) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/user/get-friend-requests'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "id": id,
        },
      ),
    );
    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      //print(data);
      List<User> users = [];
      for (var t in data) {
        users.add(
          User(
            id: t['_id'],
            firstName: t['firstName'],
            lastName: t['lastName'],
            email: t['email'],
            password: "", //hide password
            friends: t['friends'].cast<String>(),
            friendRequests: t['friendRequests'].cast<String>(),
          ),
        );
      }
      //update friendrequests in localstorage
      storage.setItem('friendRequests', users.map((e) => e.id).toList());
      return users;
    } else {
      throw Exception('Failed to load internet data');
    }
  }

  //get friends requests
  Future<List<User>> getFriends({required String id}) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/user/get-friends'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "id": id,
        },
      ),
    );
    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      //print(data);
      List<User> users = [];
      for (var t in data) {
        users.add(
          User(
            id: t['_id'],
            firstName: t['firstName'],
            lastName: t['lastName'],
            email: t['email'],
            password: "", //hide password
            friends: t['friends'].cast<String>(),
            friendRequests: t['friendRequests'].cast<String>(),
          ),
        );
      }
      //update friends in localstorage
      storage.setItem('friends', users.map((e) => e.id).toList());

      return users;
    } else {
      throw Exception('Failed to load internet data');
    }
  }

  //accept friend request
  Future acceptFriendRequest({
    required String userId,
    required String friendId,
  }) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/user/accept-friend-request'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "userId": userId,
          "friendId": friendId,
        },
      ),
    );
    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      //print(data);
      return data;
    } else {
      throw Exception('Failed to load internet data');
    }
  }

  //POST SYSTEM

  Future addPost({
    required String userId,
    required String content,
    required String privacy,
  }) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/post/add'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "userId": userId,
          "content": content,
          "privacy": privacy,
        },
      ),
    );
    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to load internet data');
    }
  }

  Future editPost({
    required String id,
    required String content,
    required String privacy,
  }) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/post/edit'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "id": id,
          "content": content,
          "privacy": privacy,
        },
      ),
    );
    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to load internet data');
    }
  }

  //delete post
  Future deletePost({
    required String id,
  }) async {
    final response = await http.delete(
      Uri.parse('http://$serverIP:3001/post/delete'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {"_id": id},
      ),
    );
    //print("HERe");
    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to load internet data');
    }
  }
}
