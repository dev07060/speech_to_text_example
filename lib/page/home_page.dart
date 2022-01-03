import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text_example/api/speech_api.dart';
import 'package:speech_to_text_example/main.dart';
import 'package:speech_to_text_example/widget/substring_highlighted.dart';
import 'package:dio/dio.dart';

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
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(MyApp.title),
        centerTitle: true,
        backgroundColor: Colors.green,
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
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.all(10).copyWith(bottom: 150),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.album),
                title: Text('BOT',
                    style: TextStyle(fontSize: 20, color: Colors.black)),
                subtitle: Text('챗봇메세지'),
              ),
              isListening
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.pink,
                    )
                  : LinearProgressIndicator(
                      value: 0,
                    ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  message,
                  style: TextStyle(fontSize: 28, color: Colors.black),
                ),
              ),
              SubstringHighlight(
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
              IconButton(
                icon: const Icon(Icons.volume_up),
                tooltip: 'Increase volume by 10',
                onPressed: () {},
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

  String _BDI_PREFIX = "http://192.168.35.22:5001/chatting/";
  Response response;
  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);

          if (!isListening) {
            Future.delayed(Duration(seconds: 2), () async {
              Response response;
              Dio dio = Dio();
              response = await dio.post("$_BDI_PREFIX$text");
              Utils.scanText(text);
              print(response.data["시스템 응답"]);
              setState(() {
                // setState() 추가.
                message = response.data["시스템 응답"];
              });
            });
          }
        },
      );
}
