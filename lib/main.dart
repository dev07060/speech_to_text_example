import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text_example/page/home_page.dart';
import 'package:speech_to_text_example/page/chat_screen.dart';
import 'package:speech_to_text_example/page/result_summary.dart';

import 'chatCode.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = '챗봇과의 대화';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.green),
        // home: HomePage(),
    initialRoute: '/',
    routes: {
      // When we navigate to the "/" route, build the FirstScreen Widget
      // "/" Route로 이동하면, FirstScreen 위젯을 생성합니다.
      '/': (context) => HomePage(),
      '/chat': (context) => ChatScreen(),
      // "/second" route로 이동하면, SecondScreen 위젯을 생성합니다.
      '/second': (context) => ResultSummary(),
    },
      );
}
