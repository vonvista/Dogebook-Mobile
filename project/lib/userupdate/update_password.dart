import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../colors.dart';
import 'package:lottie/lottie.dart';
import 'package:project/globals.dart' as globals;

import '../snackbar.dart';

import 'package:localstorage/localstorage.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  //create password controllers
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _repeatPassController = TextEditingController();

  AppColors colors = AppColors(); //app colors

  //create a global key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final LocalStorage storage = LocalStorage('project'); //local storage

  DBHelper db = DBHelper(); //helper for accessing database functions

  final StatusMessage statusMessage = StatusMessage(); //snackbar

  /// @brief: initial state on mount
  @override
  void initState() {
    super.initState();
  }

  /// @brief: create reusable input field specifically for passwords
  ///
  /// @param hintText: text to display as hint
  /// @param labelText: text to display as label
  /// @param controller: controller for textfield
  ///
  /// @return: returns a textfield with the given parameters
  Widget _passwordField(
      String hintText, String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        icon: const Icon(Icons.lock),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please $hintText';
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

  /// @brief: create update password form
  ///
  /// @return: returns a form for update password
  Widget passwordForm() {
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
                _passwordField('Enter your old password', 'Old Password',
                    _oldPassController),
                const SizedBox(height: 10),
                _passwordField('Enter your new password', 'New Password',
                    _newPassController),
                const SizedBox(height: 10),
                _passwordField('Repeat your new password', 'Repeat Password',
                    _repeatPassController),
                const SizedBox(height: 10),
                _buildButton('Update password', _handleUpdatePassword),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// @brief: function to handle update password
  ///
  /// @return: void
  void _handleUpdatePassword() async {
    //validate form
    if (_formKey.currentState!.validate()) {
      //get user details
      //check if passwords match
      if (_newPassController.text == _repeatPassController.text) {
        dynamic result = await db.updatePassword(
          userId: storage.getItem('_id'),
          oldPassword: _oldPassController.text,
          newPassword: _newPassController.text,
        );

        if (result != null) {
          //pop
          Navigator.pop(context);
        }
      } else {
        //show error
        statusMessage.showSnackBar(
            message: 'Passwords do not match', type: 'err');
      }
    }
  }

  /// @brief: the build method is called by the flutter framework.
  ///
  /// @param: context The BuildContext for the widget.
  ///
  /// @return: a widget that displays the update password page.
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
                child: globals.enableAnimation
                    ? Lottie.asset(
                        'assets/lottie/password.json',
                        height: 100,
                      )
                    : Container(),
              ),
              passwordForm(),
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
