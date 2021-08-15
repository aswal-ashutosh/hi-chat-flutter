import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi/constants/constants.dart';
import 'package:hi/provider/selected_messages.dart';
import 'package:hi/services/firebase_service.dart';
import 'package:provider/provider.dart';

class TextMessage extends StatefulWidget {
  final Message _message;
  final bool _selectionMode;
  final _selectionModeManager;

  const TextMessage(
      {required final Message message,
      required final selectionMode,
      required final selectionModeManager})
      : _message = message,
        _selectionMode = selectionMode,
        _selectionModeManager = selectionModeManager;

  @override
  _TextMessageState createState() => _TextMessageState();
}

class _TextMessageState extends State<TextMessage> {
  bool get isSelected => Provider.of<SelectedMessages>(context, listen: false)
      .contain(messageId: widget._message.messageId);

  @override
  Widget build(BuildContext context) {
    bool isMe = widget._message.sender == FirebaseService.currentUserEmail;
    final displaySize = MediaQuery.of(context).size;
    return InkWell(
      child: Container(
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
              color: isSelected
                  ? Colors.grey
                  : isMe
                      ? Colors.white
                      : Color(0x992EA043),
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
                    Text(
                      widget._message.content as String,
                      style: TextStyle(color: Colors.black, letterSpacing: 1.5),
                    ),
                    SizedBox(height: kDefaultPadding / 5.0),
                    Text(
                      widget._message.time,
                      style: TextStyle(color: Colors.black87, fontSize: 10.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: widget._selectionMode
          ? () {
              setState(() {
                if (isSelected) {
                  Provider.of<SelectedMessages>(context, listen: false)
                      .removeMessage(messageId: widget._message.messageId);
                  if (Provider.of<SelectedMessages>(context, listen: false)
                      .isEmpty) widget._selectionModeManager(false);
                } else {
                  Provider.of<SelectedMessages>(context, listen: false)
                      .addMessage(message: widget._message);
                }
              });
            }
          : null,
      onLongPress: widget._selectionMode
          ? null
          : () {
              setState(() {
                Provider.of<SelectedMessages>(context, listen: false)
                    .addMessage(message: widget._message);
                widget._selectionModeManager(true);
              });
            },
    );
  }
}
