import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../colors.dart';
import 'package:lottie/lottie.dart';

import '../models/user_model.dart';
import '../home_page.dart';
import '../signup_page.dart';

import 'package:localstorage/localstorage.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key}) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  //create email and password controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  AppColors colors = AppColors();

  //create a global key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final LocalStorage storage = LocalStorage('project');

  DBHelper db = DBHelper();

  @override
  void initState() {
    super.initState();
    //set initial value for controllers from localstorage
    _firstNameController.text = storage.getItem('firstName');
    _lastNameController.text = storage.getItem('lastName');
    _emailController.text = storage.getItem('email');
  }

  Widget _inputField(String hintText, String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        icon: Icon(Icons.person),
      ),
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
                _inputField('Enter your first name', 'First Name', _firstNameController),
                const SizedBox(height: 10),
                _inputField('Enter your last name', 'Last Name', _lastNameController),
                const SizedBox(height: 10),
                _inputField('Enter your email', 'Email', _emailController),
                const SizedBox(height: 10),
                _buildButton('Update profile', _handleUpdateUser),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleUpdateUser() async {
    //validate form
    if (_formKey.currentState!.validate()) {
      //get user details
      //check if passwords match
      print("WDADA");
      dynamic result = await db.updateUser(
        userId: storage.getItem('_id'),
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
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
        //set localstorage values
        await storage.setItem('firstName', _firstNameController.text);
        await storage.setItem('lastName', _lastNameController.text);
        await storage.setItem('email', _emailController.text);
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
