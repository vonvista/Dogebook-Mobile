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
  final LocalStorage storage = LocalStorage('project'); //local storage

  //Client http = Client();
  //set http to real client for production, set to mock client for testing

  ///!!! SERVER IP, CHANGE THIS TO YOUR SERVER IP !!!
  ///Using AVD (Android Emulator) - 10.0.2.2
  ///Using Chrome - 127.0.0.1
  ///Using external phone or device - IP of your network
  ///(usually wifi, must be connected with the same network)
  final String serverIP = "10.0.0.51";

  final int limit = 10; //limit for pagination

  final StatusMessage statusMessage = StatusMessage(); //snackbar

  /// @brief: convert ISO time to date and time format
  ///
  /// @param time: ISO time
  ///
  /// @return: returns a date and time string
  String convertTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    //return date in format: hh:mm, June 1, 2020
    //DateFormat('MMMM').format(DateTime(0, month))
    return DateFormat('hh:mm a, MMMM d, yyyy').format(dateTime);
  }

  /// @brief: user login http request
  ///
  /// @param user: user object
  ///
  /// @return: returns null or user data
  Future userLogin(Object user) async {
    try {
      final response = await http.post(
        Uri.parse('http://$serverIP:3001/user/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user),
      );
      print("HERE");
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

  /// @brief: user signup http request
  ///
  /// @param user: user object
  ///
  /// @return: returns null or user data
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

  /// @brief: get all public and user's friends posts http request
  ///
  /// @param postId: post id of last post (if empty string, get latest posts)
  /// @param userId: id of user
  ///
  /// @return: returns empty list or list of posts
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

  /// @brief: get all posts of a user http request
  ///
  /// @param id: id of user
  /// @param next: post id of last post (if empty string, get latest posts)
  ///
  /// @return: returns empty list or list of posts
  Future<List<Post>> getUserPostsLim(
    String userId,
    String id,
    String next,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://$serverIP:3001/post/get-user-posts-lim'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "limit": 10,
            "userId": userId,
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

  /// @brief: find user http request
  ///
  /// @param username: username of user
  ///
  /// @return: returns empty list or list of users
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
            friendRequests: t['friendRequests']
                .cast<String>(), // "as List<String> doesn't seem to work"
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

  /// @brief: get user http request
  ///
  /// @param id: id of user
  ///
  /// @return: returns user
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
        friendRequests: data['friendRequests']
            .cast<String>(), // "as List<String> doesn't seem to work"
      );
    } else {
      throw Exception('Failed to load internet data');
    }
  }

  //FRIEND SYSTEM

  /// @brief: send friend request http request
  ///
  /// @param userId: id of user being requested
  /// @param friendId: id of user requesting
  ///
  /// @return: returns null or data
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
        statusMessage.showSnackBar(
            message: 'Friend request sent!', type: 'suc');
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

  /// @brief: get friend requests http request
  ///
  /// @param id: id of user
  ///
  /// @return: returns empty list or list of users
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

  /// @brief: get friends http request
  ///
  /// @param id: id of user
  ///
  /// @return: returns empty list or list of users
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

  /// @brief: accept friend request http request
  ///
  /// @param userId: id of user being accepted
  /// @param friendId: id of user accepting
  ///
  /// @return: returns null or data
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
        statusMessage.showSnackBar(
            message: 'Friend request accepted!', type: 'suc');
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

  /// @brief: reject friend request http request
  ///
  /// @param userId: id of user being rejected
  /// @param friendId: id of user rejecting
  ///
  /// @return: returns null or data
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
        statusMessage.showSnackBar(
            message: 'Friend request rejected!', type: 'suc');
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

  /// @brief: remove friend http request
  ///
  /// @param userId: id of user being removed
  /// @param friendId: id of user removing
  ///
  /// @return: returns null or data
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

  /// @brief: add post http request
  ///
  /// @param userId: id of user posting
  /// @param content: content of post
  /// @param privacy: privacy of post
  ///
  /// @return: returns null or post data
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
        statusMessage.showSnackBar(message: 'Failed to load', type: 'err');
        return null;
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return null;
    }
  }

  /// @brief: edit post http request
  ///
  /// @param id: id of post being edited
  /// @param content: content of post
  /// @param privacy: privacy of post
  ///
  /// @return: returns null or post data
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
        statusMessage.showSnackBar(message: 'Failed to load', type: 'err');
        return null;
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return null;
    }
  }

  /// @brief: delete post http request
  ///
  /// @param id: id of post being deleted
  ///
  /// @return: returns null or post data
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
        statusMessage.showSnackBar(message: 'Failed to load', type: 'err');
        return null;
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return null;
    }
  }

  //COMMENTS

  /// @brief: get comments http request
  ///
  /// @param postId: id of post
  ///
  /// @return: returns empty list or list of comments
  Future<List<Comment>> getComments(String postId) async {
    List<Comment> comments = [];
    try {
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
        if ((data is! List) && data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return comments;
        }
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
        statusMessage.showSnackBar(message: 'Failed to load', type: 'err');
        return comments;
      }
    } catch (e) {
      statusMessage.showSnackBar(message: e.toString(), type: 'err');
      return comments;
    }
  }

  /// @brief: add comment http request
  ///
  /// @param postId: id of post
  /// @param userId: id of user commenting
  /// @param comment: content of comment
  ///
  /// @return: returns null or comment data
  Future addComment({
    required String postId,
    required String userId,
    required String comment,
  }) async {
    try {
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
        if (data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return null;
        }
        statusMessage.showSnackBar(message: 'Comment added', type: 'suc');
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

  /// @brief: delete comment http request
  ///
  /// @param commentId: id of comment being deleted
  ///
  /// @return: returns null or comment data
  Future deleteComment({
    required String commentId,
  }) async {
    try {
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
        if (data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return null;
        }
        statusMessage.showSnackBar(message: 'Comment deleted', type: 'suc');
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

  /// @brief: update password http request
  ///
  /// @param userId: id of user
  /// @param oldPassword: old password
  /// @param newPassword: new password
  ///
  /// @return: returns null or user data
  Future updatePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
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
        if (data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return null;
        }
        statusMessage.showSnackBar(message: 'Password updated', type: 'suc');
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

  /// @brief: update user http request
  ///
  /// @param userId: id of user
  /// @param firstName: new first name
  /// @param lastName: new last name
  /// @param email: new email
  ///
  /// @return: returns null or user data
  Future updateUser({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
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
        if (data['err'] != null) {
          statusMessage.showSnackBar(message: data['err'], type: 'err');
          return null;
        }
        statusMessage.showSnackBar(message: 'User updated', type: 'suc');
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
}
