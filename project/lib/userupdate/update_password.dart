import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../colors.dart';
import 'package:lottie/lottie.dart';

import '../models/user_model.dart';
import '../home_page.dart';
import '../signup_page.dart';

import 'package:localstorage/localstorage.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  //create email and password controllers
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _repeatPassController = TextEditingController();

  AppColors colors = AppColors();

  //create a global key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final LocalStorage storage = LocalStorage('project');

  DBHelper db = DBHelper();

  @override
  void initState() {
    super.initState();
  }

  Widget _passwordField(String hintText, String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        icon: Icon(Icons.lock),
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
                _passwordField('Enter your old password', 'Old Password', _oldPassController),
                const SizedBox(height: 10),
                _passwordField('Enter your new password', 'New Password', _newPassController),
                const SizedBox(height: 10),
                _passwordField('Repeat your new password', 'Repeat Password', _repeatPassController),
                const SizedBox(height: 10),
                _buildButton('Update password', _handleUpdatePassword),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

        if (result['err'] != null) {
          print(result['err']);
          //show snackbar error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['err']),
              //set duration
              duration: Duration(seconds: 1),
            ),
          );
        } else {
          print(result);
        }
      } else {
        //show error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            //set duration
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

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
