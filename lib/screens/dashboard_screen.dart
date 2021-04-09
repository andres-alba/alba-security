import 'package:flutter/material.dart';
import 'package:alba_security/constants.dart';

class DashBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              //margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Image.asset('images/security-guard.jpeg'),
              width: MediaQuery.of(context).size.width,
              height: 300.0,
            ),
            SizedBox(height: 30.0),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DashBoardWidget(Icons.computer, 'Scan'),
                      DashBoardWidget(Icons.computer, 'Watch Mode'),
                      DashBoardWidget(Icons.computer, 'Flash Light'),
                    ],
                  ),
                  SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DashBoardWidget(Icons.calendar_today, 'Scheduling'),
                      DashBoardWidget(Icons.policy, 'Company Policy'),
                      DashBoardWidget(Icons.report, 'Reports'),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DashBoardWidget extends StatelessWidget {
  final icon;
  final label;

  const DashBoardWidget(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1.0,
                  spreadRadius: 0.0,
                  offset: Offset(1.0, 1.0),
                ),
              ],
              color: Colors.blue,
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(color: Colors.grey)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          label,
          style: kTextStyle,
        ),
      ],
    );
  }
}
