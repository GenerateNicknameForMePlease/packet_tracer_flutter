import 'package:bot_toast/bot_toast.dart';

class ToastMsg {
  static void showToast(String message) {
    BotToast.showText(text: message);
  }
}
