import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wiscchatapp/components/rounded_button.dart';
import 'package:wiscchatapp/screens/options_screen.dart';
import 'package:flutter/material.dart';
import 'package:wiscchatapp/services/firebase_errorchecking.dart';
import 'package:wiscchatapp/components/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String enteredEmail;
  String enteredPassword;
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _showSpinner = false;
  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              CustomTextField(
                preset: 'Email',
                padding: 10.0,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => emailValidator(value),
                onSaved: (value) {
                  enteredEmail = value;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              CustomTextField(
                preset: 'Password',
                padding: 10.0,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => pwdValidator(value),
                onSaved: (value) {
                  enteredPassword = value;
                },
                obscureText: true,
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: RoundedButton(
                    text: 'Login',
                    color: Colors.lightBlueAccent,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        setState(() {
                          _showSpinner = true;
                        });
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: enteredEmail, password: enteredPassword)
                            .then((value) {
                          setState(() {
                            _showSpinner = false;
                          });
                          Navigator.pushNamedAndRemoveUntil(
                              context, OptionScreen.id, (route) => false);
                        }).catchError((onError) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return FirebaseErrors()
                                  .signInError(onError.code, context);
                            },
                          );
                          print(onError);
                          print('Error Signing Up user in Firebase');
                        });
                        setState(() {
                          _showSpinner = false;
                        });
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
