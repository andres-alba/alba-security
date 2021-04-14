import 'package:alba_security/controllers/SettingsController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alba_security/controllers/DropdownController.dart';
import 'package:alba_security/constants.dart';
import 'login_screen.dart';

final _auth = FirebaseAuth.instance;

class AdminSettings extends StatelessWidget {
  final settingsController = Get.find<SettingsController>();
  final locales = [
    {
      'name': 'English',
      'locale': Locale('en', 'US'),
    },
    {
      'name': 'Spanish',
      'locale': Locale('es', 'CO'),
    }
  ];

  updateLocale(Locale locale, BuildContext context) {
    Navigator.of(context).pop();
    Get.updateLocale(locale);
  }

  showLocalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Choose your language"),
        content: Container(
          width: double.maxFinite,
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) => InkWell(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        locales[index]['name'],
                      ),
                    ),
                    onTap: () {
                      updateLocale(locales[index]['locale'], context);
                      settingsController.setName(
                          locales[index]['name']); // set Language name on UI
                    },
                  ),
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.black),
              itemCount: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DropdownController>(builder: (controller) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                children: [
                  ListTile(
                    title: Text(
                      'settings_common'.tr,
                      style: kSettingsTitle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showLocalDialog(context);
                    },
                    title: Text('settings_language'.tr,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Obx(
                      () => Text(settingsController.language.value),
                    ),
                    leading: Icon(Icons.language),
                  ),
                  ListTile(
                    title: Text(
                      'settings_account'.tr,
                      style: kSettingsTitle,
                    ),
                  ),
                  ListTile(
                    title: Text('settings_phone'.tr),
                    leading: Icon(Icons.phone),
                  ),
                  ListTile(
                    title: Text('settings_email'.tr),
                    leading: Icon(Icons.email),
                  ),
                  ListTile(
                    onTap: () {
                      _auth.signOut();
                      Get.to(LoginScreen());
                    },
                    title: Text('settings_signout'.tr),
                    leading: Icon(Icons.logout),
                  ),
                  ListTile(
                    title: Text(
                      'settings_security'.tr,
                      style: kSettingsTitle,
                    ),
                  ),
                  ListTile(
                    title: Text('settings_lockapp'.tr),
                    leading: Icon(Icons.phonelink_lock),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
