import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class ScanController extends GetxController {
  final userName = "".obs;
  String name = "";
  String latitude, longitude;
  String address = "";
  String timeFormat = "";
  String result = "Hey there !";
  List scannedLocation = [];
  Future<String> futureAddress;

  Future<String> getUserDisplayName() async {
    final snapshot =
        await _firestore.collection('users').doc(_auth.currentUser.uid).get();
    name = snapshot.data()['displayName'];
    return name;
  }

  setName() async {
    String returnString = await getUserDisplayName();
    userName(returnString);
    update();
  }

  setSnackBar(title, message) {
    Get.snackbar(title, message,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.black,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
    update();
  }

  getCurrentLocation() async {
    try {
      final position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      latitude = '${position.latitude}';
      longitude = '${position.longitude}';
    } catch (e) {
      setSnackBar("Hello", "getCurrentLocation() Error: $e");
    }
  }

  Future<String> getAddressBasedOnLocation() async {
    try {
      final coordinates =
          new Coordinates(double.parse(latitude), double.parse(longitude));

      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      address = addresses.first.addressLine;
    } catch (e) {
      setSnackBar("Hello", "getAddressBasedOnLocation Error: $e");
    }
    return address;
  }

  Future scanQR() async {
    try {
      // QR data
      String qrResult = await BarcodeScanner.scan();

      // String location to be outputted onto screen
      String locationOneTime;

      // Current date and time
      final now = DateTime.now();
      timeFormat = DateFormat('hh:mm a').format(now);

      // get latitude and longitude coordinates
      getCurrentLocation();

      // get address based on latitude and longitude
      futureAddress = getAddressBasedOnLocation();
      address.toString();

      locationOneTime = '$qrResult scanned at $timeFormat in $address';
      print(locationOneTime);
      scannedLocation.add(locationOneTime);

      setSnackBar("Notification", "Scan Successful");

      result = qrResult;
      _firestore.collection('messages').add({
        'user': _auth.currentUser.email,
        'location': result,
        'timestamp': FieldValue.serverTimestamp(),
        'coordinates': '$latitude: $longitude',
        'address': '$address',
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setSnackBar("Hello", "Camera permission was denied");
      } else {
        setSnackBar("Hello", "Unknown error $ex");
      }
    } on FormatException {
      setSnackBar(
          "Hello", "You pressed the back button before scanning anything");
    } catch (ex) {
      setSnackBar("Hello", "Unknown Error $ex");
    }
  }
}
