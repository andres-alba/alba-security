import 'package:flutter/material.dart';
import 'package:alba_security/screens/login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:alba_security/components/rounded_button.dart';
import 'package:alba_security/constants.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);

    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 100,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Alba Patrol'],
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100.0,
            ),
            RoundedButton(
              buttonText: 'Log In',
              color: logInButtonColor,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
//            RoundedButton(
//              buttonText: 'Register',
//              color: registerButtonColor,
//              onPressed: () {
//                Navigator.pushNamed(context, RegistrationScreen.id);
//              },
//            ),
          ],
        ),
      ),
    );
  }
}
