import 'package:get/get.dart';

class DropdownController extends GetxController {
  String selectedValue;

  var language = <String>['English', 'Español'];

  void onSelected(String value) {
    selectedValue = value;
    print(selectedValue);
    update();
  }
}
