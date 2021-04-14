import 'package:flutter/material.dart';
import 'package:alba_security/screens/welcome_screen.dart';
import 'package:alba_security/screens/login_screen.dart';
import 'package:alba_security/screens/registration_screen.dart';
import 'package:alba_security/screens/user_screens/scan_screen.dart';
import 'package:alba_security/screens/user_screens/home.dart';
import 'package:alba_security/screens/admin_screens/admin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:alba_security/translations.dart';
import 'controllers/DropdownController.dart';
import 'controllers/GridController.dart';
import 'controllers/HomeController.dart';
import 'controllers/SettingsController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.lazyPut<HomeController>(() => HomeController());
  Get.lazyPut<DashboardController>(() => DashboardController());
  Get.lazyPut<DropdownController>(() => DropdownController());
  Get.lazyPut<SettingsController>(() => SettingsController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ScanScreen.id: (context) => ScanScreen(),
        AdminScreen.id: (context) => AdminScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
