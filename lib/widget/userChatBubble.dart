import 'package:flutter/material.dart';
import 'package:speech_to_text_example/components/control_panel/colors.dart';
import 'package:speech_to_text_example/models/message_data.dart';

class UserChatBubble extends StatelessWidget {
  final ChatMessageModel chatMessageModelRecord;
  const UserChatBubble({
    Key key,
    this.chatMessageModelRecord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Row(
        // if message ID is not '2' treats 'user' rest of numbers are for chatbot actions
        mainAxisAlignment: chatMessageModelRecord.id != 2
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 5,
            ),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 7 / 10,
              ),
              decoration: BoxDecoration(
                borderRadius: chatMessageModelRecord.id != 2
                    ? BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  topLeft: Radius.circular(15.0),
                )
                    : BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                color: chatMessageModelRecord.id != 2
                    ? darkblueColor
                    : primaryColor,
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 20,
              ),
              child: Text(
                "${chatMessageModelRecord.message}",
                style: TextStyle(
                  fontSize: 17,
                  // fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}