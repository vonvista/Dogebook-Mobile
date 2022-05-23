import 'package:flutter/material.dart';

import 'globals.dart';

class StatusMessage {
  /// @brief: show snackbar, used for status messages
  ///
  /// @param: message: The message to be shown
  /// @param: type: Type of the message (suc: success, err: error)
  ///
  /// @return: void
  void showSnackBar({
    required String message,
    required String type,
  }) {
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.black),
      ),
      //set duration
      duration: Duration(seconds: 3),
      backgroundColor: type == 'err'
          ? Color.fromARGB(255, 255, 145, 145)
          : Color.fromARGB(255, 133, 255, 163),
    );

    snackbarKey.currentState?.clearSnackBars();
    snackbarKey.currentState?.showSnackBar(snackBar);
  }
}
