import 'package:flutter/material.dart';
import 'package:alba_security/components/rounded_button.dart';
import 'package:alba_security/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:alba_security/screens/home.dart';
import 'dart:io';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextController = TextEditingController(text: "");
  TextEditingController passwordTextController =
      TextEditingController(text: "");
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  String email;
  String password;

  //will pop scope

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you really want to exit'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _auth.signOut(); //log out user
              exit(0); // exit app
            },
            child: Text('Exit app'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                    controller: emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'login_email'.tr,
                        icon: Icon(Icons.account_circle))),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                    controller: passwordTextController,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'login_pass'.tr, icon: Icon(Icons.lock))),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  buttonText: 'welcome_button'.tr,
                  color: kLogInButtonColor,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = (await _auth.signInWithEmailAndPassword(
                              email: email.trim(), password: password.trim()))
                          .user;
                      if (user != null) {
                        Navigator.pushNamed(context, HomeScreen.id);
                        passwordTextController.clear();
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      print(e);
                      passwordTextController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
