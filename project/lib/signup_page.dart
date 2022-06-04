import 'package:flutter/material.dart';
import 'package:project/db_helper.dart';
import 'models/user_model.dart';
import 'colors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  DBHelper db = DBHelper(); //helper for accessing database functions

  AppColors colors = AppColors(); //app colors

  //create firstname, lastname, email, password, and repeat password controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  //create a global key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// @brief: create text field for first name
  ///
  /// @return: text field for first name
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

  /// @brief: create text field for last name
  ///
  /// @return: text field for last name
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

  /// @brief: create text field for email
  ///
  /// @return: text field for email
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
        //validate if its a valid email
        if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  /// @brief: create text field for password
  ///
  /// @return: text field for password
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

  /// @brief: create text field for repeat password
  ///
  /// @return: text field for repeat password
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

  /// @brief: create reusable button
  ///
  /// @param: text: text to display on button
  /// @param: onPressed: function to call when button is pressed
  ///
  /// @return: button widget
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

  /// @brief: handle sign up button press
  ///
  /// @return: void
  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      dynamic result = await db.addUser(User(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        friends: [],
        friendRequests: [],
      ));
      if (result != null) {
        //pop the sign up page
        Navigator.pop(context);
      }
    } else {
      print('invalid');
    }
  }

  /// @brief: create form for sign up
  ///
  /// @return: form for sign up
  Widget signUpForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Card(
        //radius for card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Sign up',
                  //text size to 40
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
        ),
      ),
    );
  }

  /// @brief: the build method is called by the flutter framework.
  ///
  /// @param: context The BuildContext for the widget.
  ///
  /// @return: a widget that displays the signup page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.deg1,
      ),
      body: Center(
        child: SingleChildScrollView(
          //center
          child: Column(
            children: [
              signUpForm(),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logotitle.png',
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
