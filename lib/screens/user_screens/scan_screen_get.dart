import 'package:alba_security/controllers/ScanController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alba_security/constants.dart';
import 'package:get/get.dart';

class ScanScreenGet extends StatelessWidget {
  final scanController = Get.find<ScanController>();
  static const String id = 'scan_screen';

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
            Row(
              children: [
                Text(
                  'hi'.tr,
                  style: GoogleFonts.roboto(
                      fontSize: 30.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  ', ${scanController.userName}',
                  style: GoogleFonts.roboto(
                      fontSize: 30.0, fontWeight: FontWeight.w500),
                ),
              ],
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
                    Text('scan_please_scan'.tr,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: scanController.scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
