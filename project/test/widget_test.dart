// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:project/main.dart';
import 'package:project/login_page.dart';
import 'package:project/home_page.dart';
import 'package:project/signup_page.dart';
import 'package:project/feed_page.dart';

void main() {
  //create a mock http client

  const String serverIP = "10.0.0.51";

  final client = MockClient(
    //return a mock response
    (request) async {
      if (request.url.toString() == 'http://$serverIP:3001/user/login' &&
          request.body.toString() == '{"username":"test","password":"test"}') {
        return http.Response(
          //return a json string
          jsonEncode(
            {
              'firstName': 'Von',
              'lastName': 'Vista',
              'email': 'vovista1@up.edu.ph',
              'password': '1234',
              'friends': [],
              'friendRequests': [],
            },
          ),
          200,
        );
      } else {
        return http.Response(
          jsonEncode(
            {
              "id": "1",
              "username": "test",
              "email": "",
            },
          ),
          200,
        );
      }
    },
  );

  testWidgets('Login Page Test', (tester) async {
    // Build our app and trigger a frame.
    await tester.runAsync(() async {
      await tester.pumpWidget(MyApp());

      expect(find.byType(LoginPage), findsOneWidget);
      //find text fields
      final emailField = find.byKey(const Key('email'));
      final passwordField = find.byKey(const Key('password'));

      //find buttons
      final loginButton = find.byKey(const Key('login'));
      final signupButton = find.byKey(const Key('signup'));

      //test login
      await tester.tap(loginButton);
      await tester.pump(Duration(seconds: 1));
      //expect error message on empty email

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });
  });

  testWidgets('Successful login', (tester) async {
    // Build our app and trigger a frame.
    await tester.runAsync(() async {
      await tester.pumpWidget(MyApp());

      expect(find.byType(LoginPage), findsOneWidget);
      //find text fields
      final emailField = find.byKey(const Key('email'));
      final passwordField = find.byKey(const Key('password'));

      //find buttons
      final loginButton = find.byKey(const Key('login'));
      final signupButton = find.byKey(const Key('signup'));

      //test login
      await tester.enterText(emailField, 'vovista1@up.edu.ph');
      await tester.enterText(passwordField, '1234');
      await tester.pump();
      await tester.tap(loginButton);
      await tester.pump(Duration(seconds: 5));
    });
  });
}

class _MyHttpOverrides extends HttpOverrides {}
