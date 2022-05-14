import 'package:flutter/material.dart';
import 'services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override

  //variables for handling username and password field
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _auth = AuthService();

  //widget for input fields with validations
  Widget _buildUsernameField() {
    return TextField(
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: 'Username',
        hintText: 'Enter your username',
        icon: Icon(Icons.person),
      ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      autofocus: false,
      // validator: (String value) {
      //   if (value.isEmpty) {
      //     return 'Username is required';
      //   }
      //   return null;
      // },
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        icon: Icon(Icons.lock),
      ),
      obscureText: true,
      autocorrect: false,
      autofocus: false,
      // validator: (String value) {
      //   if (value.isEmpty) {
      //     return 'Password is required';
      //   }
      //   return null;
      // },
    );
  }

  //reusable widget for button
  Widget _buildButton(String text, Function() onPressed) {
    return ElevatedButton(
      child: Text(text),
      onPressed: onPressed,
    );
  }

  void _handleLoginAnon() async {
    dynamic result = await _auth.signInAnon();
    if (result == null) {
      print('error signing in');
    } else {
      print('signed in');
      print(result.uid);
    }
  }

  //widget for login form
  Widget _buildLoginForm() {
    return Form(
      // key: _formKey,
      child: Column(
        //center
        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          //icon image
          Image.asset('assets/images/logo.png', height: 70.0),
          _buildUsernameField(),
          SizedBox(height: 8.0),
          _buildPasswordField(),
          SizedBox(height: 8.0),
          _buildButton("Sign in", () {
            print("Sign in button pressed");
          }),
          _buildButton("Sign in anon", _handleLoginAnon),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildLoginForm(),
    );
  }
}
