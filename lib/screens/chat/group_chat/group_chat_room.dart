import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hi/constants/constants.dart';
import 'package:hi/constants/firestore_costants.dart';
import 'package:hi/custom_widget/stream_builders/circular_group_profile_picture.dart';
import 'package:hi/custom_widget/stream_builders/text_stream_builder.dart';
import 'package:hi/screens/chat/group_chat/components/group_message_text_field.dart';
import 'package:hi/screens/chat/one_to_one/components/image_message.dart';
import 'package:hi/screens/chat/one_to_one/components/text_message.dart';
import 'package:hi/services/encryption_service.dart';
import 'package:hi/services/firebase_service.dart';

class GroupChatRoom extends StatelessWidget {
  final String _roomId;

  GroupChatRoom({required final String roomId})
      : _roomId = roomId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding / 4.0),
              child: CircularGroupProfilePicture(
                roomId: _roomId,
                radius: kDefualtBorderRadius,
              ),
            ),
            SizedBox(width: kDefaultPadding / 4.0),
             TextStreamBuilder(
                  stream:
                      FirebaseService.getStreamToGroupData(roomId: _roomId),
                  key: ChatDBDocumentField.GROUP_NAME,
                ),
          ],
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseService.getStreamToChatRoom(roomId: _roomId),
              builder: (context, snapshots) {
                List<Widget> messageList = [];
                messageList.add(SizedBox(height: kDefaultPadding * 4)); //To Provide Gap After last message so that it can go above the text field level
                if (snapshots.hasData && snapshots.data != null) {
                  final messages = snapshots.data!.docs;
                  for (final message in messages) {
                    final id = message[MessageDocumentField.MESSAGE_ID];
                    final sender = message[MessageDocumentField.SENDER];
                    final time = message[MessageDocumentField.TIME];
                    final type = message[MessageDocumentField.TYPE];

                    String? content = message[MessageDocumentField.CONTENT] != null ? EncryptionService.decrypt(message[MessageDocumentField.CONTENT]) : null;

                    if (type == MessageType.TEXT) {
                      messageList.add(
                        TextMessage(
                          id: id,
                          sender: sender,
                          content: content as String,
                          time: time,
                        ),
                      );
                    } else if (type == MessageType.IMAGE) {
                      final List<String> imageUrl = [];
                      for (final url in message[MessageDocumentField.IMAGES]) {
                        imageUrl.add(EncryptionService.decrypt(url));
                      }
                      messageList.add(
                        ImageMessage(
                          id: id,
                          sender: sender,
                          content: content,
                          time: time,
                          imageUrl: imageUrl,
                        ),
                      );
                    }
                  }
                }
                return ListView(children: messageList, reverse: true);
              },
            ),
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: GroupMessageTextField(
                  roomId: _roomId,
                ),
              ),
              bottom: 0,
            )
          ],
        ),
      ),
    );
  }
}
