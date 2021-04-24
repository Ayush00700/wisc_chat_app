import 'package:wiscchatapp/components/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:wiscchatapp/constants.dart';
import 'package:flutter/rendering.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  List<String> chats = [
    'Welcome to WiscChat. We are glad that you have joined the WiscChat Team. All chats are end to end encryted for security purposes. For any queries, enter in the chat below.'
  ];
  List<String> person = ['Admin'];
  String enteredText;
  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
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
                        child: Text('Adarsh joined'),
                      ),
                    ),
                  ),
                ),
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
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                      text: chats[index],
                      sender: person[index] != 'Me' ? true : false,
                      senderName: person[index],
                      // senderName: 'Admin',
                    );
                  },
                ),
              ],
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
                          chats.add(enteredText);
                          person.add('Me');
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
    );
  }
}
