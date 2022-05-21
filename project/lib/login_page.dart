import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'colors.dart';
import 'package:lottie/lottie.dart';

import 'models/user_model.dart';
import 'home_page.dart';
import 'signup_page.dart';

import 'package:localstorage/localstorage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //create email and password controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AppColors colors = AppColors();

  //create a global key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final LocalStorage storage = LocalStorage('project');

  DBHelper db = DBHelper();

  @override
  void initState() {
    super.initState();
  }

  //create email and password text fields with validators
  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        icon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        icon: Icon(Icons.lock),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  //reusable widget for button
  Widget _buildButton(String text, Function() onPressed) {
    return ElevatedButton(
      //set button size
      child: Text(text),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        //set button color
        minimumSize: const Size.fromHeight(50),
      ),
    );
  }

  Widget _buildSignUp() {
    return Row(
      //center the buttons
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Don\'t have an account?'),
        const SizedBox(width: 10),
        //create a link to sign up page that is clickable
        ElevatedButton(
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            _handleSignUp();
          },
          style: ElevatedButton.styleFrom(
              //set the button to no background
              ),
        ),
      ],
    );
  }

  void _handleLogin() async {
    dynamic result = await db.userLogin({
      "email": _emailController.text,
      "password": _passwordController.text,
    });
    if (result['err'] != null) {
      print(result['err']);
    } else {
      //go to home page
      //set result to local storage
      print(result);
      User user = User(
        id: result['_id'],
        firstName: result['firstName'],
        lastName: result['lastName'],
        email: result['email'],
        password: result['password'],
        friends: result['friends'].cast<String>(),
        friendRequests: result['friendRequests'].cast<String>(),
      );

      await storage.setItem('_id', result['_id']);
      await storage.setItem('firstName', result['firstName']);
      await storage.setItem('lastName', result['lastName']);
      await storage.setItem('username', result['username']);
      await storage.setItem('email', result['email']);
      await storage.setItem('password', result['password']);
      await storage.setItem('friends', result['friends']);
      await storage.setItem('friendRequests', result['friendRequests']);

      //go to home page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  void _handleSignUp() {
    //navigate to signup page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpPage(),
      ),
    );
  }

  Widget loginForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Log in',
                  //text size to 40
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                _emailField(),
                const SizedBox(height: 10),
                _passwordField(),
                const SizedBox(height: 10),
                _buildButton('Login', _handleLogin),
                const SizedBox(height: 10),
                _buildSignUp(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset(
                'assets/lottie/signup.json',
                height: 200,
              ),
              loginForm(),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: colors.deg2,
    );
  }
}
