import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wiscchatapp/components/rounded_button.dart';
import 'package:wiscchatapp/screens/welcome_screen.dart';
import 'chat_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

String name;

class OptionScreen extends StatefulWidget {
  static const String id = 'option_screen';
  static String userName() {
    return name;
  }

  @override
  _OptionScreenState createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  bool _showSpinner = false;
  User _currentUser;
  String _currentUserName = '';

  void _findUserName(String email) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.email)
        .get();
    setState(() {
      _currentUserName = ds.get('name');
      name = _currentUserName;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _findUserName(_currentUser.email);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 400),
                  text: ['WiscChat'],
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "Welcome $_currentUserName",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                RoundedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ChatScreen.id);
                  },
                  text: 'Join Chat',
                  color: Colors.lightBlueAccent,
                ),
                RoundedButton(
                  onPressed: null,
                  text: 'Private Message',
                  color: Colors.lightBlueAccent,
                ),
                RoundedButton(
                  onPressed: null,
                  text: 'Settings',
                  color: Colors.lightBlueAccent,
                ),
                RoundedButton(
                  onPressed: () async {
                    setState(() {
                      _showSpinner = true;
                    });
                    await FirebaseAuth.instance.signOut();

                    setState(() {
                      _showSpinner = false;
                    });
                    Navigator.pushNamedAndRemoveUntil(
                        context, WelcomeScreen.id, (route) => false);
                  },
                  text: 'Sign Out',
                  color: Colors.grey[350],
                ),
              ]),
        ),
      ),
    );
  }
}
