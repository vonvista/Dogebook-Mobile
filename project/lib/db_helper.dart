import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/user_model.dart';
import 'models/post_model.dart';
import 'models/comment_model.dart';
import 'snackbar.dart';
import 'package:intl/intl.dart';

import 'package:localstorage/localstorage.dart';

class DBHelper {
  final LocalStorage storage = LocalStorage('project');
  final String serverIP = "10.0.0.61";

  final int limit = 10;

  final StatusMessage statusMessage = StatusMessage();

  String convertTime(String time) {
    //convert ISO time to date and time format
    DateTime dateTime = DateTime.parse(time);
    //return date in format: hh:mm, June 1, 2020
    //DateFormat('MMMM').format(DateTime(0, month))
    return DateFormat('hh:mm a, MMMM d, yyyy').format(dateTime);
  }

  Future userLogin(Object user) async {
    try {
      final response = await http.post(
        Uri.parse('http://$serverIP:3001/user/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user),
      );
      //get data from jsonplaceholder and catch error
      if (response.statusCode == 200) {
        var data = (jsonDecode(response.body));
        if (data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return null;
        }
        statusMessage.showSnackBar(message: 'Logged in!', type: 'suc');
        return data;
      } else {
        statusMessage.showSnackBar(message: 'Failed to load', type: 'err');
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return null;
    }
  }

  Future addUser(User user) async {
    try {
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
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return null;
        }
        statusMessage.showSnackBar(message: 'Signed up!', type: 'suc');
        return data;
      } else {
        throw Exception('Failed to load internet data');
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return null;
    }
  }

  Future<List<Post>> getPublicPostsLim(String postId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('http://$serverIP:3001/post/get-public-all-lim'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "limit": 10,
            "postId": postId,
            "userId": userId,
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
        statusMessage.showSnackBar(message: 'Failed to load', type: 'err');
        return [];
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return [];
    }
  }

  Future<List<Post>> getUserPostsLim(String id, String next) async {
    try {
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
        statusMessage.showSnackBar(message: 'Failed to load', type: 'err');
        return [];
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return [];
    }
  }

  Future findUser({required String username}) async {
    List<User> users = [];
    try {
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
        //print if data is json
        if ((data is! List) && data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return users;
        }
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
        statusMessage.showSnackBar(message: 'Failed to load', type: 'err');
        return users;
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return users;
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
    try {
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
        if (data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return null;
        }
        statusMessage.showSnackBar(message: 'Friend request sent!', type: 'suc');
        return data;
      } else {
        statusMessage.showSnackBar(message: 'Failed to load', type: 'err');
        return null;
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return null;
    }
  }

  //get friends requests
  Future<List<User>> getFriendRequests({required String id}) async {
    List<User> users = [];
    try {
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
        if ((data is! List) && data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return users;
        }

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
        statusMessage.showSnackBar(message: 'Failed to load', type: 'err');
        return users;
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return users;
    }
  }

  //get friends requests
  Future<List<User>> getFriends({required String id}) async {
    List<User> users = [];
    try {
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
        if ((data is! List) && data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return users;
        }

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
        return users;
      } else {
        statusMessage.showSnackBar(message: 'Failed to load', type: 'err');
        return users;
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return users;
    }
  }

  //accept friend request
  Future acceptFriendRequest({
    required String userId,
    required String friendId,
  }) async {
    try {
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
        if (data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return null;
        }
        statusMessage.showSnackBar(message: 'Friend request accepted!', type: 'suc');
        return data;
      } else {
        statusMessage.showSnackBar(message: 'Failed to load', type: 'err');
        return null;
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return null;
    }
  }

  //reject friend request
  Future rejectFriendRequest({
    required String userId,
    required String friendId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://$serverIP:3001/user/reject-friend-request'),
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
        if (data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return null;
        }
        statusMessage.showSnackBar(message: 'Friend request rejected!', type: 'suc');
        return data;
      } else {
        statusMessage.showSnackBar(message: 'Failed to load', type: 'err');
        return null;
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return null;
    }
  }

  //remove friend
  Future removeFriend({
    required String userId,
    required String friendId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://$serverIP:3001/user/remove-friend'),
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
        if (data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return null;
        }
        statusMessage.showSnackBar(message: 'Friend removed!', type: 'suc');
        return data;
      } else {
        statusMessage.showSnackBar(message: 'Failed to load', type: 'err');
        return null;
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return null;
    }
  }

  //POST SYSTEM

  Future addPost({
    required String userId,
    required String content,
    required String privacy,
  }) async {
    try {
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
        if (data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return null;
        }
        statusMessage.showSnackBar(message: 'Post created', type: 'suc');
        return data;
      } else {
        throw Exception('Failed to load internet data');
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return null;
    }
  }

  Future editPost({
    required String id,
    required String content,
    required String privacy,
  }) async {
    try {
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
        if (data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return null;
        }
        statusMessage.showSnackBar(message: 'Post edited', type: 'suc');
        return data;
      } else {
        throw Exception('Failed to load internet data');
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return null;
    }
  }

  //delete post
  Future deletePost({
    required String id,
  }) async {
    try {
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
        if (data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return null;
        }
        statusMessage.showSnackBar(message: 'Post deleted', type: 'suc');
        return data;
      } else {
        throw Exception('Failed to load internet data');
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return null;
    }
  }

  //COMMENTS

  //get comments for post
  Future<List<Comment>> getComments(String postId) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/comment/get'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "postId": postId,
        },
      ),
    );
    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      List<Comment> comments = [];
      print(data);
      for (var t in data) {
        comments.add(
          Comment(
            id: t['_id'],
            userId: t['userId']['_id'],
            name: t['userId']['firstName'] + " " + t['userId']['lastName'],
            comment: t['comment'],
            createdAt: convertTime(t['createdAt']),
          ),
        );
      }
      return comments;
    } else {
      throw Exception('Failed to load internet data');
    }
  }

  //add comment to post
  Future addComment({
    required String postId,
    required String userId,
    required String comment,
  }) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/comment/add'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "postId": postId,
          "userId": userId,
          "comment": comment,
        },
      ),
    );
    //get data from jsonplaceholder and catch error
    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      //print(data);
      print("GERERE");
      print(data);
      return data;
    } else {
      throw Exception('Failed to load internet data');
    }
  }

  //delete comment
  Future deleteComment({
    required String commentId,
  }) async {
    print(commentId);
    final response = await http.delete(
      Uri.parse('http://$serverIP:3001/comment/delete'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "id": commentId,
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

  //update password
  Future updatePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/user/update-pass'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "userId": userId,
          "oldPassword": oldPassword,
          "newPassword": newPassword,
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

  //update firstname, lastname, email
  Future updateUser({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('http://$serverIP:3001/user/update'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "userId": userId,
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
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
}
