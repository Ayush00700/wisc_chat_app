import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wiscchatapp/components/rounded_button.dart';
import 'package:wiscchatapp/screens/options_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wiscchatapp/services/firebase_errorchecking.dart';
import 'package:wiscchatapp/components/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registeration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String emailId;
  String nameId;
  String passwordId;
  bool _showSpinner = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

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

  _createUser(String name, String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .set({'name': name, 'joinedChat': false});
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailId, password: passwordId);
      setState(() {
        _showSpinner = false;
      });
      Navigator.pushNamedAndRemoveUntil(
          context, OptionScreen.id, (route) => false);
    }).catchError((onError) {
      showDialog(
        context: context,
        builder: (context) {
          return FirebaseErrors().signUpError(onError.code, context);
        },
      );
      print(onError);
      print('Error Signing Up user in Firebase');
    });

    setState(() {
      _showSpinner = false;
    });
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
                preset: 'Name',
                padding: 10.0,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value.length < 3) {
                    return "Please enter a valid Name.";
                  }
                  return null;
                },
                onSaved: (value) {
                  nameId = value;
                },
              ),
              CustomTextField(
                preset: 'Email',
                padding: 10.0,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => emailValidator(value),
                onSaved: (value) {
                  emailId = value;
                },
              ),
              CustomTextField(
                preset: 'Password',
                padding: 10.0,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => pwdValidator(value),
                onSaved: (value) {
                  passwordId = value;
                },
                obscureText: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: RoundedButton(
                    text: 'Register',
                    color: Colors.blueAccent,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        if (emailId != null && passwordId != null) {
                          setState(() {
                            _showSpinner = true;
                          });
                          await _createUser(nameId, emailId, passwordId);
                        }
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
