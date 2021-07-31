import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi/constants/constants.dart';
import 'package:hi/services/firebase_service.dart';

class TextMessage extends StatelessWidget {
  final String _id;
  final String _sender;
  final String _content;
  final String _time;
  

  const TextMessage(
      {required final String id,
      required final String sender,
      required final String content,
      required final String time})
      : _id = id,
        _sender = sender,
        _content = content,
        _time = time;
  @override
  Widget build(BuildContext context) {
    bool isMe = _sender == FirebaseService.currentUserEmail;
    final displaySize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
          top: kDefaultPadding / 5.0,
          bottom: kDefaultPadding / 5.0,
          left: isMe ? displaySize.width * .20 : kDefaultPadding / 5.0,
          right: isMe ? kDefaultPadding / 5.0 : displaySize.width * .20),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 1.0,
            color: isMe ? Color(0xAA2EA043) : Color(0xAA1F6FEB),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(kDefualtBorderRadius),
              topRight: Radius.circular(kDefualtBorderRadius),
              bottomRight:
                  isMe ? Radius.zero : Radius.circular(kDefualtBorderRadius),
              bottomLeft:
                  isMe ? Radius.circular(kDefualtBorderRadius) : Radius.zero,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(_content, style: TextStyle(color: Colors.white, letterSpacing: 1.5)),
                  SizedBox(height: kDefaultPadding / 5.0),
                  Text(_time, style: TextStyle(color: Colors.black87, fontSize: 10.0)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// const kPrimaryColor = Color(0xFF2EA043);
// const kSecondaryColor = Color(0xFF1F6FEB);