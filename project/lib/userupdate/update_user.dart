import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../colors.dart';
import 'package:lottie/lottie.dart';

import 'package:localstorage/localstorage.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key}) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  //create name and email controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  AppColors colors = AppColors(); //app colors

  //create a global key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final LocalStorage storage = LocalStorage('project'); //local storage

  DBHelper db = DBHelper(); //helper for accessing database functions

  /// @brief: initial state on mount
  @override
  void initState() {
    super.initState();
    //set initial value for controllers from localstorage
    _firstNameController.text = storage.getItem('firstName');
    _lastNameController.text = storage.getItem('lastName');
    _emailController.text = storage.getItem('email');
  }

  /// @brief: create reusable input field
  ///
  /// @param hintText: text to display as hint
  /// @param labelText: text to display as label
  /// @param controller: controller for textfield
  ///
  /// @return: returns a textfield with the given parameters
  Widget _inputField(
      String hintText, String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        icon: const Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please $hintText';
        }
        return null;
      },
    );
  }

  /// @brief: create input field for email
  ///
  /// @param: hintText: text to display as hint
  /// @param: labelText: text to display as label
  ///
  /// @return: email textfield widget
  Widget _emailField(String hintText, String labelText) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        icon: const Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please $hintText';
        }
        //check if valid email
        if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  /// @brief: reusable button widget
  ///
  /// @param text: text to display on button
  /// @param onPressed: function to call when button is pressed
  ///
  /// @return: returns a button with the given parameters
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

  /// @brief: create update user form
  ///
  /// @return: returns a form for update user
  Widget userForm() {
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
                  'Update Password',
                  //text size to 40
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Please fill in the details below',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 30),
                _inputField('Enter your first name', 'First Name',
                    _firstNameController),
                const SizedBox(height: 10),
                _inputField(
                    'Enter your last name', 'Last Name', _lastNameController),
                const SizedBox(height: 10),
                _emailField('Enter your email', 'Email'),
                const SizedBox(height: 10),
                _buildButton('Update profile', _handleUpdateUser),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// @brief: function to handle update user
  ///
  /// @return: void
  void _handleUpdateUser() async {
    //validate form
    if (_formKey.currentState!.validate()) {
      dynamic result = await db.updateUser(
        userId: storage.getItem('_id'),
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
      );

      if (result != null) {
        //set localstorage values
        await storage.setItem('firstName', _firstNameController.text);
        await storage.setItem('lastName', _lastNameController.text);
        await storage.setItem('email', _emailController.text);
        //pop navigator
        Navigator.pop(context);
      }
    }
  }

  /// @brief: the build method is called by the flutter framework.
  ///
  /// @param: context The BuildContext for the widget.
  ///
  /// @return: a widget that displays the update user page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.deg1,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Lottie.asset('assets/lottie/profile.json', height: 100),
              ),
              userForm(),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: colors.deg2,
    );
  }
}
