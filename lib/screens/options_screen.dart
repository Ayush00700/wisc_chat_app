import 'package:wiscchatapp/components/rounded_button.dart';
import 'package:wiscchatapp/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class OptionScreen extends StatelessWidget {
  static const String id = 'option_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  fontSize: 35.0,
                  fontWeight: FontWeight.w900,
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
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, WelcomeScreen.id, (route) => false);
                },
                text: 'Sign Out',
                color: Colors.grey[350],
              ),
            ]),
      ),
    );
  }
}
