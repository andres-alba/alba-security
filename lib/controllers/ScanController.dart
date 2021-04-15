import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class ScanController extends GetxController {
  final userName = "".obs;
  String name = "";
  String latitude, longitude;
  String address = "";

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
}
