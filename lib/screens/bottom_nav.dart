import 'package:alba_security/screens/time_screen.dart';
import 'package:alba_security/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alba_security/controllers/HomeController.dart';
import 'dashboard_screen.dart';
import 'scan_screen.dart';

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: controller.tabIndex,
            children: [
              DashBoardScreen(),
              ScanScreen(),
              TimeScreen(),
              SettingsScreen(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.redAccent,
          onTap: controller.changeTabIndex,
          currentIndex: controller.tabIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 5,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'bottomnav_home'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: 'bottomnav_scan'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lock_clock),
              label: 'bottomnav_clock'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'bottomnav_settings'.tr,
            ),
          ],
        ),
      );
    });
  }
}
