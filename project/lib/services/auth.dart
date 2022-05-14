//firebase auth
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //auth change user stream
  Stream<UserClass?> get user {
    return _auth.authStateChanges().map(
          (User? user) => user == null ? null : UserClass(uid: user.uid),
        );
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user as User;
      return UserClass(
        uid: user.uid,
      );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
