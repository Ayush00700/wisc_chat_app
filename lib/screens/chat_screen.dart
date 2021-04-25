import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wiscchatapp/components/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:wiscchatapp/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:wiscchatapp/screens/options_screen.dart';
import 'package:wiscchatapp/services/on_press_delete.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  String enteredText;
  bool _showSpinner = false;
  String _currentUserName = '';
  User _currentUser;

  void _findUserName() {
    _currentUserName = OptionScreen.userName();
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    _currentUser = FirebaseAuth.instance.currentUser;
    _findUserName();
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                //Implement logout functionality
              }),
        ],
        title: Row(
          children: [
            Hero(
              tag: 'logo',
              child: Container(
                height: 40.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'WiscChat',
            ),
          ],
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ListView(
                  reverse: true,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chats')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          List<String> chats = [];
                          List<String> person = [];
                          List<String> time = [];
                          final chatmessages = snapshot.data.docs;
                          for (DocumentSnapshot chat in chatmessages) {
                            chats.add(chat.get('chat').toString());
                            person.add(chat.get('name').toString());
                            time.add(chat.id);
                          }
                          return ListView.builder(
                            // scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: chats.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onLongPress: () {
                                  if (person[index] == _currentUserName) {
                                    DeleteFunction('Chat', (int id) {
                                      FirebaseFirestore.instance
                                          .collection('chats')
                                          .doc(time[id])
                                          .delete();
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                    }, (bool spin) {
                                      setState(() {
                                        _showSpinner = spin;
                                      });
                                    }).showDialogBox(context, index);
                                  }
                                },
                                child: ChatBubble(
                                  text: chats[index],
                                  sender: person[index] != _currentUserName
                                      ? true
                                      : false,
                                  senderName: person[index] != _currentUserName
                                      ? person[index]
                                      : 'Me',
                                ),
                              );
                            },
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Text('You joined'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          enteredText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          messageTextController.clear();
                          if (enteredText != null) {
                            FirebaseFirestore.instance
                                .collection('chats')
                                .doc(DateTime.now().toString())
                                .set({
                              'name': _currentUserName,
                              'email': _currentUser.email,
                              'chat': enteredText
                            });
                            enteredText = null;
                          }
                        });
                        //Implement send functionality.
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
