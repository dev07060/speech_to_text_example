import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'package:speech_to_text_example/components/control_panel/colors.dart';
import 'package:speech_to_text_example/components/control_panel/commands.dart';
import 'package:speech_to_text_example/models/message_data.dart';
import 'package:speech_to_text_example/widget/substring_highlighted.dart';
import 'package:speech_to_text_example/widget/messageStream.dart';
import 'package:speech_to_text_example/controllers/preference.dart';
import 'package:speech_to_text_example/api/speech_api.dart';
import '../utils.dart';

ChatMessageModel _chatMessagesModel = ChatMessageModel();

class ChatScreen extends StatefulWidget {

  static const String id = 'chat_screen9';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String email = "1111@test.net";
  String text = '음성이나 텍스트를 입력해주세요';
  String message = '안녕하세요? \n대화형 문진에 오신걸 환영합니다.';
  String distType = '';

  bool isListening = false;
  bool isText = false;
  bool isCommand = false;
  bool isLoading = false;
  List chatData = [];
  int yn = 0;

  @override
  void initState() {
    isCommand = false;
    super.initState();
  }

  @override
  void dispose() {
    toggleRecording();
    toggleKeyboard();
    super.dispose();
    // Do some action when screen is closed
  }


  final _messageTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterTop,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        endRadius: 75,
        glowColor: Theme.of(context).primaryColor.withOpacity(0.5),
        child: FloatingActionButton(
          child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
          onPressed: () {
            setState(() => isText = false);
            setState(() => text = '');
            _messageTextController.clear();
            toggleRecording();
          },
          backgroundColor: darkblueColor,
        ),
      ),
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '대화형 문진',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        backgroundColor: primaryColor,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.analytics),
              onPressed: ()  {
                Navigator.pushNamed(context, '/second');
                // await FlutterClipboard.copy(text);
                // Scaffold.of(context).showSnackBar(
                //   SnackBar(content: Text('✓   Copied to Clipboard')),
                // );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: primaryColor,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: <Widget>[
                          const ListTile(
                            leading: CircleAvatar(
                              radius: 33,
                              backgroundImage:
                                  AssetImage("assets/img/model.png"),
                            ),
                            title: Text('MetaDoc',
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black)),
                            subtitle: Text('듣고 있습니다',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black54)),
                          ),
                          isListening
                          ? LinearProgressIndicator(
                              backgroundColor: Colors.pink[100],
                            )
                          : LinearProgressIndicator(
                              value: 0,
                            ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 15, left: 10, right: 10),
                            child: Text(message,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                                maxLines: 3),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            child: Center(
                              child: SubstringHighlight(
                                text: text,
                                terms: Command.all,
                                textStyle: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                                textStyleHighlight: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          isText
                          ? Container(
                              width: 330,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextField(
                                autofocus: true,
                                decoration: InputDecoration(
                                    fillColor: Colors.white30,
                                    filled: true,
                                    border: InputBorder.none),
                                onSubmitted: (value) {
                                  setState(() => this.text = value.trim());
                                  setState(() => this.isText = false);
                                  // text = "";
                                  _messageTextController.clear();
                                  bubbleGenerate(value.trim(), 1,  '-');
                                  maxScrolling();
                                  // straightCommand(value, isText);
                                  toggleKeyboard();
                                },
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.keyboard),
                              tooltip: '키보드 입력 버튼',
                              onPressed: () {
                                setState(() => this.isText = true);
                            },
                          ),
                        ],
                      ),
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

  // ignore: non_constant_identifier_names

  // function for user typing keyboard to send message
  // (includes : dio connection, create chat bubble)
  Future toggleKeyboard() async {

    print("ddddddddddddd$distType");
    additionalCommand(distType);
    straightCommand(text).then((d) => setState(() => isCommand = d));
    // additionalCommand(distType);
    print("isCommand : $isCommand / isText: $isText");

    if(!isCommand) {
      print("straightCommand  $isText");
      if (text != ''.trim()) {
        await dioConnection(bdi_call, email, text)
            .then((value) => setState(() => [message = value[0], distType = value[1]]));
        maxScrolling();
      } else {
        setState(() => {
          isText = false
        });
      }
    }
  }

  // voice recognition function (includes : dio connection, create chat bubble)
  Future toggleRecording() => SpeechApi.toggleRecording(
    onResult: (text) => setState(() => this.text = text),
    onListening: (isListening) {
      setState(() => this.isListening = isListening);
      if (!isListening) {
        Future.delayed(Duration(seconds: 2), () async {
          bubbleGenerate(text, 1, '');
          maxScrolling();

          await dioConnection(bdi_call, email, text)
              .then((value) => setState(() => message = value[0]));
          maxScrolling();
        });
      } else {
        message = "";
      }
    },
  );
}


Future <List>dioConnection(String _end, String _email, String _userMsg) async {

  var formData = FormData.fromMap({
    'input_text': _userMsg,
    'present_bdi': '',
  });

  Dio dio = new Dio();
  Response response = await dio.post("$url$_end$_email", data:formData);
  Utils.scanText(_userMsg);
  String chat = response.data["분석결과"]["시스템응답"];
  String bdi = response.data["생성된 질문"]["질문"];
  String dist = response.data["사용자 입력 BDI 분류"]["분류 결과"];
  String b_dist = response.data["입출력데이터"]["BDI분류"];
  int yn = response.data["입력문장긍부정도"]["긍부정구분"]["분류 결과"];
  if (_userMsg != ''.trim()) {
    if(dist == "일반") {
      bubbleGenerate(chat, 2, b_dist);
      return [chat, b_dist];
    } else {
      bubbleGenerate(bdi, 2, b_dist);
      return [bdi, b_dist];
    }
  }
}
// Dio http function end

