import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alba_security/controllers/DropdownController.dart';
import 'package:alba_security/constants.dart';

class SettingsScreen extends StatelessWidget {
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
                      'Common',
                      style: kSettingsTitle,
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    title: Text('Language',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text('English'),
                    leading: Icon(Icons.language),
                  ),
                  ListTile(
                    title: Text(
                      'Account',
                      style: kSettingsTitle,
                    ),
                  ),
                  ListTile(
                    title: Text('Phone Number'),
                    leading: Icon(Icons.phone),
                  ),
                  ListTile(
                    title: Text('Email'),
                    leading: Icon(Icons.email),
                  ),
                  ListTile(
                    title: Text('Sign out'),
                    leading: Icon(Icons.logout),
                  ),
                  ListTile(
                    title: Text(
                      'Security',
                      style: kSettingsTitle,
                    ),
                  ),
                  ListTile(
                    title: Text('Lock app in background'),
                    leading: Icon(Icons.phonelink_lock),
                  ),
                ],
              ),
            ),
//            DropdownButton<String>(
//              hint: Text('Language'),
//              value: controller.selectedValue,
//              onChanged: (newValue) {
//                controller.onSelected(newValue);
//              },
//              elevation: 5,
//              items: controller.language.map((String dropDownStringItem) {
//                return DropdownMenuItem<String>(
//                  child: Text(dropDownStringItem),
//                  value: dropDownStringItem,
//                );
//              }).toList(),
//            ),
//            SizedBox(height: 100.0),
          ],
        ),
      );
    });
  }
}
