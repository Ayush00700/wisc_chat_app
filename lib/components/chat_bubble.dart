import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool sender;
  final String senderName;
  ChatBubble({
    @required this.text,
    this.sender = false,
    this.senderName = "Me",
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: sender
          ? EdgeInsets.only(top: 8, bottom: 8, left: 40, right: 16)
          : EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: sender ? Colors.lightBlueAccent[100] : Colors.grey[200],
              borderRadius: sender
                  ? BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Column(
                crossAxisAlignment:
                    sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    senderName,
                    textAlign: sender ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    text,
                    // textAlign: sender ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
