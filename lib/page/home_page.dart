import 'package:flutter/material.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
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

  String email = "1111@test.net";
  String text = '';
  String message = '안녕하세요?';
  bool isListening = false;
  bool isText = false;
  List chatData = [];
  bool isLoading = false;

  ScrollController controller = new ScrollController();

  @override
  void initState() {
    super.initState();
    this.fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    // Do some action when screen is closed
  }

  fetchData() async {
    Dio dio = new Dio();
    Response response;
    var url = "http://192.168.0.37:5001/api/results/";

    setState(() {
      isLoading = true;
    });
    response = await dio.get("$url$email");

    if (response.statusCode == 200) {
      var items = response.data['chat'];
      setState(() {
        chatData = items;
        isLoading = false;
      });
      print(response.data["chat"]);
    } else {
      chatData = [];
      isLoading = false;
    }
  }

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
              onPressed: ()  {
                Navigator.pushNamed(context, '/chat');
              },
            ),
          ),
        ],
        elevation: 0,
      ),

      body: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.all(10).copyWith(bottom: 150),
        child: Column(children: <Widget>[
          Container(
            height: 350,
            child: !isLoading
                ? ListView.builder(
                    controller: controller,
                    shrinkWrap: true,
                    itemCount: chatData == null ? 0 : chatData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8, top: 8, left: 10, right: 10),
                          child: ListTile(
                            title: Text(chatData[index]['bot'],
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black38,
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(chatData[index]['user'],
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black)),
                          ),
                        ),
                      );
                    })
                : Text("대화 기록이 없습니다."),
          ),
          Card(
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
                  title: Text('BOT',
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20, color: Colors.black)),
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
                  child: Text(message,
                      style: TextStyle(fontSize: 24, color: Colors.black),
                      maxLines: 2),
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
                            setState(() => this.text = value);
                            setState(() => this.isText = false);
                            // text = "";
                            toggleKeyboard();
                          },
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.keyboard),
                        tooltip: 'Increase volume by 10',
                        onPressed: () {
                          setState(() => this.isText = true);
                          print(isText);
                        },
                      ),
              ],
            ),
          ),
        ]),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        endRadius: 75,
        glowColor: Theme.of(context).primaryColor,
        child: FloatingActionButton(
          child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
          onPressed: () {
            setState(() => isText = false);
            toggleRecording();
          },
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  String bdi_call = "bdiscale?email=";
  String chat_call = "chat_rest/";
  String prefix = "http://192.168.0.37:5001/";

  Response response;

  Future toggleKeyboard() async {

    if (!isText) {
      var formData = FormData.fromMap({
        'input_text': text,
        'present_bdi': '',
      });
      // Future.delayed(Duration(seconds: 2), () async {
        Dio dio = Dio();
        response =
            await dio.post("$prefix$bdi_call$email", data: formData);
        Utils.scanText(text);
        final position = controller.position.maxScrollExtent;
        String chat = response.data["분석결과"]["시스템응답"];
        String bdi = response.data["생성된 질문"]["질문"];
        String dist = response.data["사용자 입력 BDI 분류"]["분류 결과"];
        int yn = response.data["입력문장긍부정도"]["긍부정구분"]["분류 결과"];

        print("$yn,, $bdi,,,$chat");
        controller.animateTo(
          position,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeOut,
        );
        // answering
        setState(() {
          // print bdi questionnaire if answer was yes or no
          switch(yn) {
            case 0:
              message = bdi;
              break;
            case 1:
              message = bdi;
              break;
            case 2 :
              message = chat;
              break;
            default:
              message = "통신이 원활하지 않습니다";
          }
          // end switch case
        });
    }
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);
          var formData = FormData.fromMap({
            'input_text': text,
            'present_bdi': '',
          });


          if (text == ''){
            setState(() async => {
              message = "인식된 음성이 없습니다.",
              isListening = true
            });
          } else if (!isListening) {
            Future.delayed(Duration(seconds: 2), () async {
              Response response;
              Dio dio = Dio();
              try{
              response =
                  await dio.post("$prefix$bdi_call$email", data: formData);

              } catch(e) {
                print("error message : $e");
              }
              Utils.scanText(text);
              final position = controller.position.maxScrollExtent;
              String chat = await response.data["분석결과"]["시스템응답"];
              String bdi = await response.data["생성된 질문"]["질문"];
              String dist = await response.data["사용자 입력 BDI 분류"]["분류 결과"];
              int yn = await response.data["입력문장긍부정도"]["긍부정구분"]["분류 결과"];

              print(yn);
              controller.animateTo(
                position,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
              // answering
              setState(() {
                // print bdi questionnaire if answer was yes or no
                switch(yn) {
                  case 0:
                    message = bdi;
                    break;
                  case 1:
                    message = bdi;
                    break;
                  case 2 :
                    message = chat;
                    break;
                  default:
                    message = "통신이 원활하지 않습니다";
                }
              });
            });
          } else {
            message = "";
          }
        },
      );
}
