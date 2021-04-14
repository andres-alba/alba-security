import 'package:alba_security/screens/user_screens/time_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alba_security/controllers/HomeController.dart';
import 'package:alba_security/screens/admin_screens/admin_create_location.dart';
import 'package:alba_security/screens/admin_screens/admin_screen.dart';
import 'package:alba_security/screens/admin_screens/admin_settings.dart';

class AdminBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: controller.tabIndex,
            children: [
              AdminScreen(),
              AdminLocations(),
              TimeScreen(),
              AdminSettings(),
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
              label: 'admin_bottomnav_home'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: 'admin_bottomnav_create'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lock_clock),
              label: 'admin_bottomnav_clock'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'admin_bottomnav_settings'.tr,
            ),
          ],
        ),
      );
    });
  }
}
