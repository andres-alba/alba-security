import 'package:get/get.dart';

class SettingsController extends GetxController {
  final language = "English".obs;

  setName(String languageName) {
    language(languageName);
  }
}
