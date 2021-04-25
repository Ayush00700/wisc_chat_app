import 'package:flutter/material.dart';

class FirebaseErrors {
  AlertDialog signUpError(String errorCode, BuildContext context) {
    return dialogbox(context, errorCode);
  }

  AlertDialog signInError(String errorCode, BuildContext context) {
    return dialogbox(context, errorCode);
  }

  AlertDialog dialogbox(BuildContext context, String errorMessage) {
    return AlertDialog(
      title: Text("Error"),
      content: Text(errorMessage),
      actions: <Widget>[
        TextButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
            //Spinner
          },
        )
      ],
    );
  }
}
