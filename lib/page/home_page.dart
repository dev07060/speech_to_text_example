import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text_example/api/speech_api.dart';
import 'package:speech_to_text_example/main.dart';
import 'package:speech_to_text_example/widget/substring_highlighted.dart';
import 'package:dio/dio.dart';
// import 'package:flutter_tts/flutter_tts.dart';

import '../utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = '반가워요';
  String message = '안녕하세요?';

  bool isListening = false;
  bool isText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text(MyApp.title),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.content_copy),
              onPressed: () async {
                await FlutterClipboard.copy(text);
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('✓   Copied to Clipboard')),
                );
              },
            ),
          ),
        ],
        elevation: 0,
      ),

      body: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.all(10).copyWith(bottom: 150),
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
                  backgroundImage: AssetImage("assets/img/model.png"),
                ),
                title: Flexible(
                  child: Text('BOT',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                ),
                subtitle: Text('챗봇메세지',
                    style: TextStyle(fontSize: 17, color: Colors.black54)),
              ),
              isListening
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.pink[100],
                    )
                  : LinearProgressIndicator(
                      value: 0,
                    ),
              Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 15, left: 10, right: 10),
                child: Expanded(
                  child: Text(message,
                      style: TextStyle(fontSize: 24, color: Colors.black),
                      maxLines: 2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Center(
                  child: SubstringHighlight(
                    text: text,
                    terms: Command.all,
                    textStyle: TextStyle(
                      fontSize: 22.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                    textStyleHighlight: TextStyle(
                      fontSize: 22.0,
                      color: Colors.red,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              isText
                  ? IconButton(
                      icon: const Icon(Icons.keyboard),
                      tooltip: 'Increase volume by 10',
                      onPressed: () {
                        setState(() => this.isText = false);
                        print(isText);
                      },
                    )
                  : TextField(
                      decoration: InputDecoration(),
                      onSubmitted: (value) {
                        setState(() => this.text = value);
                        setState(() => this.isText = true);
                        text = "";
                        toggleKeyboard();
                      },
                    ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        endRadius: 75,
        glowColor: Theme.of(context).primaryColor,
        child: FloatingActionButton(
          child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
          onPressed: toggleRecording,
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  String email = "1111@test.com";
  String bdi_call = "bdiscale?email=";
  String _BDI_PREFIX = "http://192.168.0.37:5001/";
  Response response;

  Future toggleKeyboard() async {
    if (isText) {
      Dio dio = Dio();
      response = await dio.post("$_BDI_PREFIX$bdi_call$email");
      Utils.scanText(text);
      print(response.data["시스템 응답"]);
      setState(() {
        // setState() 추가.
        message = response.data["시스템 응답"];
      });
    }
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        // onSuccess: (message) => tts.speak(this.message),
        onResult: (text) => setState(() => this.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);
          var formData = FormData.fromMap({
            'input_text': text,
            'present_bdi': '',
          });
          if (!isListening) {
            Future.delayed(Duration(seconds: 2), () async {
              Response response;
              Dio dio = Dio();
              response = await dio.post("$_BDI_PREFIX", data: formData);
              Utils.scanText(text);
              String chat = await response.data["분석결과"]["시스템 응답"];
              String bdi = await response.data["생성된 질문"]["질문"];
              print(chat);
              setState(() {
                // setState() 추가.
                message = bdi;
              });
            });
          } else {
            message = "";
          }
        },
      );
}
