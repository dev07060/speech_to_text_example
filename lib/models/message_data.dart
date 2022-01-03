// To parse this JSON data, do
//
//     final passengersData = passengersDataFromJson(jsonString);

import 'dart:convert';

MessageData messageDataDataFromJson(String str) =>
    MessageData.fromJson(json.decode(str));

String messageDataToJson(MessageData data) => json.encode(data.toJson());

class MessageData {
  MessageData({
    this.greeting,
    this.instructions,
    this.userMessage,
    this.botMessage,
  });

  String greeting;
  List<String> instructions;
  String userMessage;
  String botMessage;

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
        greeting: json["greeting"],
        instructions: List<String>.from(json["instructions"].map((x) => x)),
        userMessage: json["userMessage"],
        botMessage: json["botMessage"],
      );

  Map<String, dynamic> toJson() => {
        "greeting": greeting,
        "instructions": List<dynamic>.from(instructions.map((x) => x)),
        "userMessage": userMessage,
        "botMessage": botMessage,
      };
}
