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
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/chat': (context) => ChatScreen(),
          '/second': (context) => ResultSummary(),
        },
      );
}
