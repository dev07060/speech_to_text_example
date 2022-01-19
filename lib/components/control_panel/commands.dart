import 'package:speech_to_text_example/controllers/preference.dart';
import 'package:speech_to_text_example/widget/messageStream.dart';

import 'dialog.dart';

Future straightCommand(String _userInput, bool _isCommand) async {
  if (_userInput.contains("그만")) {
    return bubbleGenerate(
        (stopCommands..shuffle()).first, 2, 'straightCommand');
  } else if (_userInput.contains("안녕")) {
    return bubbleGenerate(
        (helloCommands..shuffle()).first, 2, 'straightCommand');
  }
  return _isCommand = true;
}

Future additionalCommand(String _botOutput, int _flow) async {
  if (_botOutput == bdiDist[16]) {
    print(
        "in func $_botOutput == ${bdiDist[16]},,,${_botOutput == bdiDist[16]}");
    print("ss213$_flow");
    return bubbleGenerate(
        (additionalMessage[16][11]..shuffle()).first, 2, 'additionalCommand');
  }
}

Future throwsTopic(String _botOutput) async {
  return bubbleGenerate(
      (additionalMessage[16][11]..shuffle()).first, 2, 'topic');
}
