import 'package:alba_security/controllers/ScanController.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alba_security/constants.dart';
import 'package:get/get.dart';

class ScanScreenGet extends StatelessWidget {
  final scanController = Get.find<ScanController>();
  static const String id = 'scan_screen';

  //scanController.getUserDisplayName();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String timeFormat;
  List scannedLocation = [];
  int selectedValue = 1;
  //String displayName = "";

  // Geolocator points
  String latitude = "";
  String longitude = "";
  String address = "";

  // Get current location
  getCurrentLocation() async {
    try {
      final position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      latitude = '${position.latitude}';
      longitude = '${position.longitude}';
    } catch (e) {
      print(e);
    }
  }

  getAddressBasedOnLocation() async {
    final coordinates =
        new Coordinates(double.parse(latitude), double.parse(longitude));

    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    address = addresses.first.addressLine;
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

      getCurrentLocation();
      getAddressBasedOnLocation();

      locationOneTime = '$qrResult scanned at $timeFormat in $address}';
      scannedLocation.add(locationOneTime);

      Get.snackbar("Notification", "Scan Successful");
      result = qrResult;
      _firestore.collection('messages').add({
        'user': _auth.currentUser.email,
        'location': result,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        Get.snackbar("Notification", "Camera permission was denied");
      } else {
        Get.snackbar("Notification", "Unknown error $ex");
      }
    } on FormatException {
      Get.snackbar("Notification",
          "You pressed the back button before scanning anything");
    } catch (ex) {
      Get.snackbar("Notification", "Unknown Error $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    scanController.setName();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Text(
              '$monthDay',
              style: GoogleFonts.roboto(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Hi, ${scanController.userName}',
              style: GoogleFonts.roboto(
                  fontSize: 30.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
              height: 200.0,
              width: 500.0,
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0),
                    Text('Please scan the following Locations:',
                        style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange)),
                    SizedBox(height: 10.0),
                    Text(
                      'Location 1: Entrance\nLocation 2: Parking Lot\nLocation 3: Kitchen\nLocation 4: Security Room',
                      style: GoogleFonts.roboto(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
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
