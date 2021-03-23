import 'package:flutter/material.dart';
import 'package:alba_security/screens/welcome_screen.dart';
import 'package:alba_security/screens/login_screen.dart';
import 'package:alba_security/screens/registration_screen.dart';
import 'package:alba_security/screens/scan_screen.dart';
import 'package:provider/provider.dart';
import 'package:alba_security/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:alba_security/models/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ScanScreen.id: (context) => ScanScreen(),
      },
    );
  }
}
