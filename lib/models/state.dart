import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:alba_security/components/alert_message.dart';
import 'package:intl/intl.dart';

String result = "Hey there !";
List scannedLocation = [];
final locationOne = "09:02 PM";
String timeFormat;
bool scannedOnTime = false;
String locationOneWalkTimeOne = '02:00 AM';
String locationOneWalkTimeTwo = '02:10 AM';

class LocationState extends ChangeNotifier {
  // QR Scan
  Future<void> scanQR(BuildContext context) async {
    try {
      // QR data
      String qrResult = await BarcodeScanner.scan();

      // String location to be outputted onto screen
      String locationOneTime;

      // Current date and time
      final now = DateTime.now();
      timeFormat = DateFormat('hh:mm a').format(now);

      //getCurrentLocation();
      //getAddressBasedOnLocation();
      if (result == 'Location # 1' && locationOne == timeFormat) {
        locationOneTime = "Location found at $locationOne";
        scannedOnTime = true;
      } else {
        locationOneTime = '$qrResult scanned at $timeFormat}';
        scannedLocation.add(locationOneTime);
      }

      //scanAlert(context, locationOneTime);
    } catch (e) {
      print('unknown error');
    }
    notifyListeners();
  }
}

class LocationNotifier with ChangeNotifier {}
