import 'package:bot_toast/bot_toast.dart';

void showToast(String msg, [int seconds = 4]) {
  BotToast.showText(text: msg, duration: Duration(seconds: seconds));
}