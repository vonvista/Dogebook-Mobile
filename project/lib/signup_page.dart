import 'package:flutter/material.dart';
import 'package:project/db_helper.dart';
import 'models/user_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  DBHelper db = DBHelper();

  //create username, email, password, and repeat password controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  //create a global key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //create username, email, password, and repeat password text fields with validators

  Widget _firstNameField() {
    return TextFormField(
      controller: _firstNameController,
      decoration: const InputDecoration(
        labelText: 'First Name',
        hintText: 'Enter your first name',
        icon: Icon(Icons.person),
      ),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your first name';
        }
        return null;
      },
    );
  }

  Widget _lastNameField() {
    return TextFormField(
      controller: _lastNameController,
      decoration: const InputDecoration(
        labelText: 'Last Name',
        hintText: 'Enter your last name',
        icon: Icon(Icons.person),
      ),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your last name';
        }
        return null;
      },
    );
  }

  //email text field
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
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _repeatPasswordField() {
    return TextFormField(
      controller: _repeatPasswordController,
      decoration: const InputDecoration(
        labelText: 'Repeat Password',
        hintText: 'Enter your password again',
        icon: Icon(Icons.lock),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password again';
        } else if (_passwordController.text != _repeatPasswordController.text) {
          return 'Passwords do not match';
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
        primary: Colors.blue,
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
            print("Go to signup");
          },
          style: ElevatedButton.styleFrom(
              //set the button to no background
              ),
        ),
      ],
    );
  }

  void _handleSignUp() {}

  //build SignUpPage without using scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Stack(
          children: [
            //create back button to go back to login page
            Align(
              //position on upper left
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Sign up',
                    //text size to 40
                    style: TextStyle(fontSize: 40),
                  ),
                  const SizedBox(height: 30),
                  _firstNameField(),
                  const SizedBox(height: 10),
                  _lastNameField(),
                  const SizedBox(height: 10),
                  _emailField(),
                  const SizedBox(height: 10),
                  _passwordField(),
                  const SizedBox(height: 10),
                  _repeatPasswordField(),
                  const SizedBox(height: 10),
                  _buildButton('Sign Up', _handleSignUp),
                  //create back button on upper left of screen
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
