import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:alba_security/components/alert_message.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

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

  // Geolocator points
  String latitude = "";
  String longitude = "";
  String address = "";

  @override
  void initState() {
    super.initState();
    getAddressBasedOnLocation();
  }

  // Get current location
  getCurrentLocation() async {
    try {
      final position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
        latitude = '${position.latitude}';
        longitude = '${position.longitude}';
      });
    } catch (e) {
      print(e);
    }
  }

  getAddressBasedOnLocation() async {
    final coordinates =
        new Coordinates(double.parse(latitude), double.parse(longitude));

    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      address = addresses.first.addressLine;
    });
  }

  String result = "Hey there !";
  String locationOneWalkTimeOne = '02:00 AM';
  String locationOneWalkTimeTwo = '02:10 AM';

  // QR Scan
  Future _scanQR() async {
    try {
      // QR data
      String qrResult = await BarcodeScanner.scan();

      // String location to be outputted onto screen
      String locationOneTime;

      // Current date and time
      final now = DateTime.now();
      timeFormat = DateFormat('hh:mm a').format(now);

      final locationOne = "09:02 PM";
      getCurrentLocation();
      getAddressBasedOnLocation();
      if (result == 'Location # 1' && locationOne == timeFormat) {
        locationOneTime = "Location found at $locationOne";
        scannedOnTime = true;
      } else {
        locationOneTime = '$qrResult scanned at $timeFormat in $address}';
        scannedLocation.add(locationOneTime);
      }

      setState(() {
        result = qrResult;
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
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Text(
              'Please scan the following Locations:',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Location 1: Entrance\nLocation 2: Parking Lot\nLocation 3: Kitchen\nLocation 4: Security Room',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
//            DropdownButton(
//              value: selectedValue,
//              icon: Icon(Icons.arrow_downward_rounded),
//              iconSize: 22,
//              elevation: 16,
//              style: TextStyle(color: Colors.black),
//              onChanged: (value) {
//                setState(() {
//                  selectedValue = value;
//                });
//              },
//              items: [
//                DropdownMenuItem(
//                  child: Text("Location 1"),
//                  value: 1,
//                ),
//                DropdownMenuItem(
//                  child: Text("Location 2"),
//                  value: 2,
//                ),
//                DropdownMenuItem(
//                  child: Text("Location 3"),
//                  value: 3,
//                ),
//              ],
//            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                  itemCount: scannedLocation.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${scannedLocation[index]}'),
                    );
                  }),
            ),
          ],
        ),
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
