import 'package:flutter/material.dart';

import 'login_page.dart';

import 'colors.dart';
import 'globals.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /// @brief: This is the main function of the whole app.
  ///
  /// @param: context: The context of the app.
  ///
  /// @return: The main app widget.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey:
          snackbarKey, // to have a global key for the snackbar (used for status messages)
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //elevated button styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors().deg2),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
