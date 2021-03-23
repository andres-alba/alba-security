import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'login_screen.dart';
import 'package:alba_security/components/alert_message.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ScanScreen extends StatefulWidget {
  static const String id = 'scan_screen';
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String timeFormat;
  List scannedLocation = [];
  bool scannedOnTime = false;

  int selectedValue = 1;

  @override
  void initState() {
    super.initState();

    print(_auth.currentUser);

    //getCurrentUser();
  }

  String result = "Hey there !";
  String resultTime = "";
  String locationOneWalkTimeOne = '02:00 AM';
  String locationOneWalkTimeTwo = '02:10 AM';

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      String locationOneTime;
      final now = DateTime.now();
      timeFormat = DateFormat('hh:mm a').format(now);
      print('xxxxxxxxxxxxxxXXXXXXXXXXXXXXX');
      //final nowTime = timeFormat.parseStrict(now.toString());
      //print(nowTime);

      final locationOne = "09:02 PM";
      print('resulttttttt: $result');
      print('resulttttttt: $timeFormat');
      if (result == 'Location # 1' && locationOne == timeFormat) {
        locationOneTime = "Location found at $locationOne";
        scannedOnTime = true;
      } else {
        locationOneTime = 'Location $selectedValue scanned at $timeFormat';
        scannedLocation.add(locationOneTime);
      }
      print(scannedLocation);

      setState(() {
        result = qrResult;
        resultTime = locationOneTime;
        _firestore.collection('messages').add({
          'user': _auth.currentUser.email,
          'location': result,
          'timestamp': FieldValue.serverTimestamp(),
          'approved': scannedOnTime.toString(),
        });
      });
      scanAlert(context, locationOneTime);
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        scanAlert(context, 'Camera permission was denied');
//        setState(() {
//          result = "Camera permission was denied";
//        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, LoginScreen.id);
              }),
        ],
        title: Text(
          'Welcome ${_auth.currentUser.email}!',
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.0),
          Text(
            '    Please select the Location:',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 20.0),
          DropdownButton(
            value: selectedValue,
            icon: Icon(Icons.arrow_downward_rounded),
            iconSize: 22,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
            items: [
              DropdownMenuItem(
                child: Text("Location 1"),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text("Location 2"),
                value: 2,
              ),
              DropdownMenuItem(
                child: Text("Location 3"),
                value: 3,
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
                itemCount: 1,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('$scannedLocation'),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.check),
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
