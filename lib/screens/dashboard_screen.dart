import 'package:alba_security/screens/scan_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alba_security/constants.dart';
import 'package:get/get.dart';
import 'package:alba_security/controllers/GridController.dart';
import 'login_screen.dart';
import 'package:torch_compat/torch_compat.dart';

final _auth = FirebaseAuth.instance;

class DashBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Do you really want to log out'),
          actions: [
            TextButton(
              onPressed: () {
                _auth.signOut();
                Get.back();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _auth.signOut();
                Get.to(LoginScreen());
              },
              child: Text('Log out'),
            ),
          ],
        ),
      );
    }

    return GetBuilder<DashboardController>(builder: (controller) {
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  //margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Image.asset('images/security-guard.jpeg'),
                  width: MediaQuery.of(context).size.width,
                  height: 300.0,
                ),
                SizedBox(height: 30.0),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DashBoardWidget(Icons.qr_code_scanner,
                              'dashboard_scan'.tr, ScanScreen()),
                          DashBoardWidget(Icons.computer, 'dashboard_watch'.tr,
                              ScanScreen()),
                          RawMaterialButton(
                            onPressed: () async {
                              if (controller.isFlashOn) {
                                TorchCompat.turnOn();
                                controller.isFlashOn = false;
                              } else if (controller.isFlashOn == false) {
                                TorchCompat.turnOff();
                                controller.isFlashOn = true;
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 1.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(1.0, 1.0),
                                        ),
                                      ],
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(50.0),
                                      border: Border.all(color: Colors.grey)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Icon(
                                          Icons.lightbulb,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'dashboard_light'.tr,
                                  style: kTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DashBoardWidget(Icons.calendar_today,
                              'dashboard_schedule'.tr, ScanScreen()),
                          DashBoardWidget(Icons.policy, 'dashboard_policy'.tr,
                              ScanScreen()),
                          DashBoardWidget(Icons.report, 'dashboard_reports'.tr,
                              ScanScreen()),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class DashBoardWidget extends StatelessWidget {
  final icon;
  final label;
  final screen;

  const DashBoardWidget(this.icon, this.label, this.screen);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return RawMaterialButton(
        onPressed: () {
          controller.isCurrentlyTouching = true;
          Get.to(screen);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 1.0,
                      spreadRadius: 0.0,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(color: Colors.grey)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              label,
              style: kTextStyle,
            ),
          ],
        ),
      );
    });
  }
}
