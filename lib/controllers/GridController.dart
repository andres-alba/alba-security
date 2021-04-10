import 'package:get/get.dart';

class DashboardController extends GetxController {
  bool isCurrentlyTouching = false;
  bool isFlashOn = false;

  void handleTouch(bool isTouching) {
    isCurrentlyTouching = isTouching;
    update();
  }

  void handleFlash(bool isOn) {
    isFlashOn = isOn;
    update();
  }
}
