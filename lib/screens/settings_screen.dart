import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alba_security/controllers/DropdownController.dart';
import 'package:alba_security/constants.dart';

class SettingsScreen extends StatelessWidget {
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
                    subtitle: Text('English'),
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
                    title: Text('Sign out'),
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
