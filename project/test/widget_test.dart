// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:project/main.dart' as app;
import 'package:project/login_page.dart';
import 'package:project/home_page.dart';
import 'package:project/signup_page.dart';
import 'package:project/feed_page.dart';
import 'package:project/profile_page.dart';
import 'package:project/search_page.dart';
import 'package:project/comments_page.dart';
import 'package:project/friend_page.dart';
import 'package:project/db_helper.dart';

const users = [
  {
    'firstName': 'Von',
    'lastName': 'Vista',
    'email': 'vovista1@up.edu.ph',
    'password': '1234',
    'friends': [],
    'friendRequests': [],
  },
  {
    'firstName': 'A',
    'lastName': 'A',
    'email': 'a@gmail.com',
    'password': '1234',
    'friends': [],
    'friendRequests': [],
  },
];

void main() {
  const String serverIP = "127.0.0.1";

  // (request) async {
  //     //print username from body of request
  //     final body = json.decode(request.body);
  //     print(body);
  //     if (request.url.toString() == 'http://$serverIP:3001/user/login' &&
  //         request.body.toString() == '{"username":"test","password":"test"}') {
  //       return http.Response(
  //         //return a json string
  //         jsonEncode(
  //           {
  //             'firstName': 'Von',
  //             'lastName': 'Vista',
  //             'email': 'vovista1@up.edu.ph',
  //             'password': '1234',
  //             'friends': [],
  //             'friendRequests': [],
  //           },
  //         ),
  //         200,
  //       );
  //     } else {
  //       return http.Response(
  //         jsonEncode(
  //           {
  //             "id": "1",
  //             "username": "test",
  //             "email": "",
  //           },
  //         ),
  //         201,
  //       );
  //     }
  //   },

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Login Page Tests', () {
    testWidgets('Pressing sign up without any of the fields filled up',
        (tester) async {
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 5));

        expect(find.byType(LoginPage), findsOneWidget);

        final emailField = find.byType(TextFormField).at(0);
        final passwordField = find.byType(TextFormField).at(1);

        final loginButton = find.byType(ElevatedButton).at(0);
        final signupButton = find.byType(ElevatedButton).at(1);

        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Please enter your email'), findsOneWidget);
        expect(find.text('Please enter your password'), findsOneWidget);
      });
    });

    testWidgets('Logging in with an email not registered in the system',
        (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 5));

        expect(find.byType(LoginPage), findsOneWidget);

        final emailField = find.byType(TextFormField).at(0);
        final passwordField = find.byType(TextFormField).at(1);

        final loginButton = find.byType(ElevatedButton).at(0);
        final signupButton = find.byType(ElevatedButton).at(1);

        await tester.enterText(emailField, 'notinsystem@up.edu.ph');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Email not registered'), findsOneWidget);
      });
    });

    testWidgets('Signing up with all fields field appropriately',
        (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 5));

        final emailField = find.byType(TextFormField).at(0);
        final passwordField = find.byType(TextFormField).at(1);

        final loginButton = find.byType(ElevatedButton).at(0);
        final signupButton = find.byType(ElevatedButton).at(1);

        await tester.enterText(emailField, 'vovista1@up.edu.ph');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 5));
        await tester.pump(Duration(seconds: 5));

        expect(find.byType(HomePage), findsOneWidget);
      });
    });

    testWidgets('Logging in with an incorrect password', (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 5));

        expect(find.byType(LoginPage), findsOneWidget);

        final emailField = find.byType(TextFormField).at(0);
        final passwordField = find.byType(TextFormField).at(1);

        final loginButton = find.byType(ElevatedButton).at(0);
        final signupButton = find.byType(ElevatedButton).at(1);

        await tester.enterText(emailField, 'vonatsiv1030@gmail.com');
        await tester.enterText(passwordField, '123');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Incorrect password'), findsOneWidget);
      });
    });
  });

  group('Signup Page Tests', () {
    testWidgets('Pressing sign up without any of the fields filled up',
        (tester) async {
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));
        expect(find.byType(LoginPage), findsOneWidget);

        var signUpButton = find.byType(ElevatedButton).at(1);
        await tester.tap(signUpButton);
        await tester.pump(Duration(seconds: 2));
        expect(find.byType(SignUpPage), findsOneWidget);

        var firstName = find.byType(TextFormField).at(0);
        var lastName = find.byType(TextFormField).at(1);
        var email = find.byType(TextFormField).at(2);
        var password = find.byType(TextFormField).at(3);
        var repeatPassword = find.byType(TextFormField).at(4);

        signUpButton = find.byType(ElevatedButton).at(0);

        await tester.tap(signUpButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Please enter your first name'), findsOneWidget);
        expect(find.text('Please enter your last name'), findsOneWidget);
        expect(find.text('Please enter your email'), findsOneWidget);
        expect(find.text('Please enter your password'), findsOneWidget);
        expect(find.text('Please enter your password again'), findsOneWidget);
      });
    });

    testWidgets(
        'Signing up with non-matching passwords on password and repeat password fields',
        (tester) async {
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));
        expect(find.byType(LoginPage), findsOneWidget);

        var signUpButton = find.byType(ElevatedButton).at(1);
        await tester.tap(signUpButton);
        await tester.pump(Duration(seconds: 2));
        expect(find.byType(SignUpPage), findsOneWidget);

        var firstName = find.byType(TextFormField).at(0);
        var lastName = find.byType(TextFormField).at(1);
        var email = find.byType(TextFormField).at(2);
        var password = find.byType(TextFormField).at(3);
        var repeatPassword = find.byType(TextFormField).at(4);

        await tester.enterText(firstName, 'Von');
        await tester.enterText(lastName, 'Vista');
        await tester.enterText(email, 'vonatsiv1030@gmail.com');
        await tester.enterText(password, '123');
        await tester.enterText(repeatPassword, '1234');

        signUpButton = find.byType(ElevatedButton).at(0);

        await tester.tap(signUpButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Passwords do not match'), findsOneWidget);
      });
    });

    //REDACTED: Test for successful signup is removed to prevent spamming of accounts

    testWidgets('Signing up with an email that is already registered',
        (tester) async {
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));
        expect(find.byType(LoginPage), findsOneWidget);

        var signUpButton = find.byType(ElevatedButton).at(1);
        await tester.tap(signUpButton);
        await tester.pump(Duration(seconds: 2));
        expect(find.byType(SignUpPage), findsOneWidget);

        var firstName = find.byType(TextFormField).at(0);
        var lastName = find.byType(TextFormField).at(1);
        var email = find.byType(TextFormField).at(2);
        var password = find.byType(TextFormField).at(3);
        var repeatPassword = find.byType(TextFormField).at(4);

        await tester.enterText(firstName, 'Von');
        await tester.enterText(lastName, 'Vista');
        await tester.enterText(email, 'vonatsiv1030@gmail.com');
        await tester.enterText(password, '1234');
        await tester.enterText(repeatPassword, '1234');

        signUpButton = find.byType(ElevatedButton).at(0);

        await tester.tap(signUpButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('There is already a user with this email'),
            findsOneWidget);
      });
    });

    testWidgets('Signing up with invalid email', (tester) async {
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));
        expect(find.byType(LoginPage), findsOneWidget);

        var signUpButton = find.byType(ElevatedButton).at(1);
        await tester.tap(signUpButton);
        await tester.pump(Duration(seconds: 2));
        expect(find.byType(SignUpPage), findsOneWidget);

        var firstName = find.byType(TextFormField).at(0);
        var lastName = find.byType(TextFormField).at(1);
        var email = find.byType(TextFormField).at(2);
        var password = find.byType(TextFormField).at(3);
        var repeatPassword = find.byType(TextFormField).at(4);

        await tester.enterText(firstName, 'Von');
        await tester.enterText(lastName, 'Vista');
        await tester.enterText(email, 'vonatsiv1030');
        await tester.enterText(password, '1234');
        await tester.enterText(repeatPassword, '1234');

        signUpButton = find.byType(ElevatedButton).at(0);

        await tester.tap(signUpButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Please enter a valid email'), findsOneWidget);
      });
    });
  });

  group('Feed Page Tests', () {
    testWidgets('Create and delete a post', (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));

        var emailField = find.byType(TextFormField).at(0);
        var passwordField = find.byType(TextFormField).at(1);

        var loginButton = find.byType(ElevatedButton).at(0);

        await tester.enterText(emailField, 'vonatsiv1030@gmail.com');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Feed), findsOneWidget);

        var createPostButton = find.byType(ElevatedButton).at(0);
        await tester.tap(createPostButton);
        await tester.pump(Duration(seconds: 2));
        var postTextField = find.byType(TextField).at(0);
        await tester.enterText(postTextField, 'This is a test post');
        await tester.pump(Duration(seconds: 2));
        var postButton = find.byKey(Key('postModalButton'));
        await tester.tap(postButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Post created'), findsOneWidget);

        //delete the post created
        var deletePostButton = find.byType(IconButton).at(1);
        await tester.tap(deletePostButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Post deleted'), findsOneWidget);
      });
    });

    testWidgets('Creat empty post', (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));

        var emailField = find.byType(TextFormField).at(0);
        var passwordField = find.byType(TextFormField).at(1);

        var loginButton = find.byType(ElevatedButton).at(0);

        await tester.enterText(emailField, 'vonatsiv1030@gmail.com');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Feed), findsOneWidget);

        var createPostButton = find.byType(ElevatedButton).at(0);
        await tester.tap(createPostButton);
        await tester.pump(Duration(seconds: 2));
        var postTextField = find.byType(TextField).at(0);
        await tester.pump(Duration(seconds: 2));
        var postButton = find.byKey(Key('postModalButton'));
        await tester.tap(postButton);
        await tester.pump(Duration(seconds: 2));

        //this means di kumasa yung post, which is success
        expect(find.text('What\'s on your mind?'), findsOneWidget);
      });
    });

    testWidgets('Edit post', (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));

        var emailField = find.byType(TextFormField).at(0);
        var passwordField = find.byType(TextFormField).at(1);

        var loginButton = find.byType(ElevatedButton).at(0);

        await tester.enterText(emailField, 'vonatsiv1030@gmail.com');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Feed), findsOneWidget);

        var createPostButton = find.byType(ElevatedButton).at(0);
        await tester.tap(createPostButton);
        await tester.pump(Duration(seconds: 2));
        var postTextField = find.byType(TextField).at(0);
        await tester.enterText(postTextField, 'This is a test post');
        await tester.pump(Duration(seconds: 2));
        var postButton = find.byKey(Key('postModalButton'));
        await tester.tap(postButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Post created'), findsOneWidget);

        //edit post
        var editPostButton = find.byType(IconButton).at(0);
        await tester.tap(editPostButton);
        await tester.pump(Duration(seconds: 2));
        postTextField = find.byType(TextField).at(0);
        await tester.enterText(postTextField, 'This is a edited post');
        await tester.pump(Duration(seconds: 2));
        postButton = find.byKey(Key('postModalButton'));
        await tester.tap(postButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Post edited'), findsOneWidget);

        //delete the post created
        var deletePostButton = find.byType(IconButton).at(1);
        await tester.tap(deletePostButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Post deleted'), findsOneWidget);
      });
    });

    testWidgets('Edit post and make content empty', (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));

        var emailField = find.byType(TextFormField).at(0);
        var passwordField = find.byType(TextFormField).at(1);

        var loginButton = find.byType(ElevatedButton).at(0);

        await tester.enterText(emailField, 'vonatsiv1030@gmail.com');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Feed), findsOneWidget);

        var createPostButton = find.byType(ElevatedButton).at(0);
        await tester.tap(createPostButton);
        await tester.pump(Duration(seconds: 2));
        var postTextField = find.byType(TextField).at(0);
        await tester.enterText(postTextField, 'This is a test post');
        await tester.pump(Duration(seconds: 2));
        var postButton = find.byKey(Key('postModalButton'));
        await tester.tap(postButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Post created'), findsOneWidget);

        //edit post
        var editPostButton = find.byType(IconButton).at(0);
        await tester.tap(editPostButton);
        await tester.pump(Duration(seconds: 2));
        postTextField = find.byType(TextField).at(0);
        await tester.enterText(postTextField, '');
        await tester.pump(Duration(seconds: 2));
        postButton = find.byKey(Key('postModalButton'));
        await tester.tap(postButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Unable to save post'), findsOneWidget);

        var closePostButton = find.byKey(Key('closeModalButton'));
        await tester.tap(closePostButton);
        await tester.pump(Duration(seconds: 2));

        //delete the post created
        var deletePostButton = find.byType(IconButton).at(1);
        await tester.tap(deletePostButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Post deleted'), findsOneWidget);
      });
    });

    testWidgets('Load more posts', (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));

        var emailField = find.byType(TextFormField).at(0);
        var passwordField = find.byType(TextFormField).at(1);

        var loginButton = find.byType(ElevatedButton).at(0);

        await tester.enterText(emailField, 'vonatsiv1030@gmail.com');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Feed), findsOneWidget);

        var loadMorePosts = find.byKey(Key('loadMoreButton'));
        await tester.tap(loadMorePosts);

        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Feed), findsOneWidget);
        //this one is hard to measure in terms of what to expect
      });
    });
  });

  group('Comments Page Tests', () {
    testWidgets('Add and Delete Comment', (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));

        var emailField = find.byType(TextFormField).at(0);
        var passwordField = find.byType(TextFormField).at(1);

        var loginButton = find.byType(ElevatedButton).at(0);

        await tester.enterText(emailField, 'vonatsiv1030@gmail.com');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Feed), findsOneWidget);

        var createPostButton = find.byType(ElevatedButton).at(0);
        await tester.tap(createPostButton);
        await tester.pump(Duration(seconds: 2));
        var postTextField = find.byType(TextField).at(0);
        await tester.enterText(postTextField, 'This is a test post');
        await tester.pump(Duration(seconds: 2));
        var postButton = find.byKey(Key('postModalButton'));
        await tester.tap(postButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Post created'), findsOneWidget);

        //go to comments
        var commentsButton = find.byType(ElevatedButton).at(1);
        await tester.tap(commentsButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Comments), findsOneWidget);

        var commentTextField = find.byType(TextField).at(0);
        await tester.enterText(commentTextField, 'This is a test comment');
        await tester.pump(Duration(seconds: 2));
        var commentButton = find.byType(IconButton).at(0);
        await tester.tap(commentButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Comment added'), findsOneWidget);

        var deleteButton = find.byType(IconButton).at(1);
        await tester.tap(deleteButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Comment deleted'), findsOneWidget);

        //delete everything ng ginawa
        var backButton = find.byTooltip('Back');
        await tester.tap(backButton);
        await tester.pump(Duration(seconds: 2));

        //delete the post created
        var deletePostButton = find.byType(IconButton).at(1);
        await tester.tap(deletePostButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Post deleted'), findsOneWidget);
      });
    });
  });

  group('Search Page Tests', () {
    testWidgets('Search for user using first name or last name',
        (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));

        var emailField = find.byType(TextFormField).at(0);
        var passwordField = find.byType(TextFormField).at(1);

        var loginButton = find.byType(ElevatedButton).at(0);

        await tester.enterText(emailField, 'vonatsiv1030@gmail.com');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Feed), findsOneWidget);

        var searchNav = find.byTooltip('Search');
        await tester.tap(searchNav);
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(SearchPage), findsOneWidget);

        var searchField = find.byType(TextField).at(0);
        var searchButton = find.byType(IconButton).at(0);

        await tester.enterText(searchField, 'user');
        await tester.pump(Duration(seconds: 2));

        await tester.tap(searchButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(ListTile), findsWidgets);
      });
    });

    testWidgets('Search with nothing', (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));

        var emailField = find.byType(TextFormField).at(0);
        var passwordField = find.byType(TextFormField).at(1);

        var loginButton = find.byType(ElevatedButton).at(0);

        await tester.enterText(emailField, 'vonatsiv1030@gmail.com');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Feed), findsOneWidget);

        var searchNav = find.byTooltip('Search');
        await tester.tap(searchNav);
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(SearchPage), findsOneWidget);

        var searchField = find.byType(TextField).at(0);
        var searchButton = find.byType(IconButton).at(0);

        await tester.enterText(searchField, '');
        await tester.pump(Duration(seconds: 2));

        await tester.tap(searchButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(ListTile), findsNothing);
      });
    });

    testWidgets('Tapping on a user on the search page', (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));

        var emailField = find.byType(TextFormField).at(0);
        var passwordField = find.byType(TextFormField).at(1);

        var loginButton = find.byType(ElevatedButton).at(0);

        await tester.enterText(emailField, 'vonatsiv1030@gmail.com');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Feed), findsOneWidget);

        var searchNav = find.byTooltip('Search');
        await tester.tap(searchNav);
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(SearchPage), findsOneWidget);

        var searchField = find.byType(TextField).at(0);
        var searchButton = find.byType(IconButton).at(0);

        await tester.enterText(searchField, 'user');
        await tester.pump(Duration(seconds: 2));

        await tester.tap(searchButton);
        await tester.pump(Duration(seconds: 2));

        var user = find.byType(ListTile).at(0);
        await tester.tap(user);
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(ProfilePage), findsOneWidget);
      });
    });
  });

  group('Profile Page Tests', () {
    testWidgets('Visiting a profile wherein you\'re already friends',
        (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));

        var emailField = find.byType(TextFormField).at(0);
        var passwordField = find.byType(TextFormField).at(1);

        var loginButton = find.byType(ElevatedButton).at(0);

        await tester.enterText(emailField, 'vonatsiv1030@gmail.com');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Feed), findsOneWidget);

        var searchNav = find.byTooltip('Search');
        await tester.tap(searchNav);
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(SearchPage), findsOneWidget);

        var searchField = find.byType(TextField).at(0);
        var searchButton = find.byType(IconButton).at(0);

        await tester.enterText(searchField, 'user');
        await tester.pump(Duration(seconds: 2));

        await tester.tap(searchButton);
        await tester.pump(Duration(seconds: 5));

        var user = find.byType(ListTile).at(0);
        await tester.tap(user);
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(ProfilePage), findsOneWidget);
        expect(find.text('Friends'), findsOneWidget);
      });
    });

    testWidgets(
        "Sending friend request (on a profile that you've already sent before)",
        (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));

        var emailField = find.byType(TextFormField).at(0);
        var passwordField = find.byType(TextFormField).at(1);

        var loginButton = find.byType(ElevatedButton).at(0);

        await tester.enterText(emailField, 'vonatsiv1030@gmail.com');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Feed), findsOneWidget);

        var searchNav = find.byTooltip('Search');
        await tester.tap(searchNav);
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(SearchPage), findsOneWidget);

        var searchField = find.byType(TextField).at(0);
        var searchButton = find.byType(IconButton).at(0);

        await tester.enterText(searchField, 'von');
        await tester.pump(Duration(seconds: 2));

        await tester.tap(searchButton);
        await tester.pump(Duration(seconds: 5));

        var user = find.byType(ListTile).last;
        await tester.tap(user);
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(ProfilePage), findsOneWidget);

        var sendButton = find.byType(ElevatedButton).at(0);
        await tester.tap(sendButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Friend request already sent'), findsOneWidget);
      });
    });

    testWidgets("Visiting your own profile", (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));

        var emailField = find.byType(TextFormField).at(0);
        var passwordField = find.byType(TextFormField).at(1);

        var loginButton = find.byType(ElevatedButton).at(0);

        await tester.enterText(emailField, 'vonatsiv1030@gmail.com');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Feed), findsOneWidget);

        var searchNav = find.byTooltip('Search');
        await tester.tap(searchNav);
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(SearchPage), findsOneWidget);

        var searchField = find.byType(TextField).at(0);
        var searchButton = find.byType(IconButton).at(0);

        await tester.enterText(searchField, 'von');
        await tester.pump(Duration(seconds: 2));

        await tester.tap(searchButton);
        await tester.pump(Duration(seconds: 5));

        var user = find.byType(ListTile).first;
        await tester.tap(user);
        await tester.pump(Duration(seconds: 5));

        expect(find.byType(ProfilePage), findsOneWidget);
        expect(find.text('Edit Profile'), findsOneWidget);
      });
    });
  });

  group('Friend Page Tests', () {
    testWidgets(
        "Accepting a friend request when it is already on the friend limit",
        (tester) async {
      // Build our app and trigger a frame.
      await tester.runAsync(() async {
        app.main();
        await tester.pump(Duration(seconds: 2));

        var emailField = find.byType(TextFormField).at(0);
        var passwordField = find.byType(TextFormField).at(1);

        var loginButton = find.byType(ElevatedButton).at(0);

        await tester.enterText(emailField, 'vonatsiv1030@gmail.com');
        await tester.enterText(passwordField, '1234');
        await tester.pump();
        await tester.tap(loginButton);
        await tester.pump(Duration(seconds: 2));
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(Feed), findsOneWidget);

        var friendsNav = find.byTooltip('Friends');
        await tester.tap(friendsNav);
        await tester.pump(Duration(seconds: 2));

        expect(find.byType(FriendPage), findsOneWidget);

        var acceptButton = find.byType(IconButton).at(0);
        await tester.tap(acceptButton);
        await tester.pump(Duration(seconds: 2));

        expect(find.text('Friend limit reached (8 friends)'), findsOneWidget);
      });
    });

    //REDACTED: Tests that are not implemented as test cases
    //-Accepting friend request (not on friend limit)
    //-Declining friend request
    //-Removing friend
  });
}
