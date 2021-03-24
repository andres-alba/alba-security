import 'package:flutter/material.dart';
import 'package:alba_security/components/rounded_button.dart';
import 'package:alba_security/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:alba_security/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alba_security/screens/admin_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      hintText: 'Enter your email')),
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
                      hintText: 'Enter your Password')),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                buttonText: 'Log In',
                color: logInButtonColor,
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
                    }
                    setState(() {
                      showSpinner = false;
                    });
                    emailTextController.clear();
                    passwordTextController.clear();
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
