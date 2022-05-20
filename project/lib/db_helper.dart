import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'models/user_model.dart';

import 'package:localstorage/localstorage.dart';

class DBHelper {
  final LocalStorage storage = LocalStorage('project');

  final String serverIP = "10.0.0.61";

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
}
