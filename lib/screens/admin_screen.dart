import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'location_history_screen.dart';
import 'login_screen.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:alba_security/constants.dart';

final _auth = FirebaseAuth.instance;
final _db = FirebaseFirestore.instance;

class AdminScreen extends StatefulWidget {
  static const String id = 'admin_screen';
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final now = DateTime.now();

  int totalLocations = 4;

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you really want to log out'),
        actions: [
          TextButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pushNamed(context, LoginScreen.id);
            },
            child: Text('Log out'),
          ),
        ],
      ),
    );
  }

  void _checkNumberLocations() async {
    final snapshot =
        await _db.collection('users').doc('lrXD7wcnmUXRlHDQSyyPoh0UEuP2').get();
    final locations = int.parse(snapshot.data()['locations']);
    totalLocations = locations;
  }

  @override
  void initState() {
    _checkNumberLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  'Hi, Admin',
                  style: GoogleFonts.roboto(
                      fontSize: 30.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 40.0),
                Text(
                  'Locations Scanned',
                  style: GoogleFonts.roboto(fontSize: 20.0),
                ),
                Container(
                  height: 200.0,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _db
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: LinearProgressIndicator(),
                        );
                      }
                      // grab all documents from 'messages' collections
                      final messages = snapshot.data.docs;

                      // array where location details will be stored
                      List lastScannedTime = [];

                      // for every document inside all documents
                      for (var message in messages) {
                        //print(message.data());
                        final location = message.data()['location'];
                        final user = message.data()['user'];
                        final scannedTime =
                            message.data()['timestamp'].toDate();
                        lastScannedTime.add(scannedTime);
                      }
                      print(lastScannedTime[0]);

                      return Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: totalLocations,
                          itemBuilder: (context, i) {
                            //print('Location # ${i + 1}');
                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => LocationHistoryScreen(
                                      locationNumber: i + 1),
                                );
                              },
                              child: LocationCard(
                                locationName: 'Location ${i + 1}',
                                firebaseLocationName: 'Location # ${i + 1}',
                                scannedTime: lastScannedTime[0],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LocationCard extends StatelessWidget {
  final locationName;
  final scannedTime;
  final firebaseLocationName;

  const LocationCard(
      {@required this.locationName,
      this.scannedTime,
      this.firebaseLocationName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 50.0),
      height: 40.0,
      width: 200.0,
      child: Card(
        elevation: 5.0,
        //margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '$locationName',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  child: Icon(Icons.arrow_right),
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Text(
              ' last scan:',
              style: TextStyle(fontSize: 15.0, color: Colors.grey),
            ),
            Container(
              width: 100.0,
              height: 50.0,
              child: StreamBuilder<QuerySnapshot>(
                stream: _db
                    .collection('messages')
                    .where('location', isEqualTo: '$firebaseLocationName')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  // grab all documents from 'messages' collections
                  final messages = snapshot.data.docs;

                  // array where location details will be stored
                  List lastScannedTime = [];

                  // for every document inside all documents
                  for (var message in messages) {
                    //print(message.data());
                    final location = message.data()['location'];
                    final user = message.data()['user'];
                    final scannedTime = message.data()['timestamp'].toDate();
                    lastScannedTime.add(scannedTime);
                  }
                  if (lastScannedTime.isNotEmpty) {
                    return Text(
                      '${DateFormat.yMMMMd().add_jm().format(lastScannedTime[0])}',
                      style: TextStyle(fontSize: 15.0),
                    );
                  } else {
                    return Text('No Scan Information');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
