import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'login_screen.dart';

final _auth = FirebaseAuth.instance;

class AdminScreen extends StatefulWidget {
  static const String id = 'admin_screen';
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _db = FirebaseFirestore.instance;

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
                Text('Last Locations Scanned'),
                StreamBuilder<QuerySnapshot>(
                  stream: _db.collection('messages').snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: LinearProgressIndicator(),
                      );
                    }

                    // grab all documents from 'messages' collections
                    final messages = snapshot.data.docs;

                    // array where location details will be stored
                    List<LocationMessage> locationMessages = [];

                    // for every document inside all documents
                    for (var message in messages) {
                      final location = message.data()['location'];
                      final user = message.data()['user'];
                      final scannedTime = message.data()['timestamp'].toDate();
                      final approved = message.data()['approved'];

                      // change timestamp to readable String
                      final formattedDate =
                          DateFormat.yMMMMd().add_jm().format(scannedTime);

                      final locationMessage = LocationMessage(
                        user: user.toString(),
                        location: location.toString(),
                        scannedTime: formattedDate,
                        approved: approved,
                      );
                      locationMessages.add(locationMessage);
                    }

                    return Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        children: locationMessages,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LocationMessage extends StatelessWidget {
  final String location;
  final String user;
  final String approved;
  final String scannedTime;

  const LocationMessage(
      {this.location, this.user, this.approved, this.scannedTime});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$location',
          style: TextStyle(
              fontSize: 14.0, color: Colors.green, fontWeight: FontWeight.w700),
        ),
        Text(
          ' scanned on ',
          style: TextStyle(
              fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w700),
        ),
        Text(
          '$scannedTime',
          style: TextStyle(
              fontSize: 14.0, color: Colors.blue, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
