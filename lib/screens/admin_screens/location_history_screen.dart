import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _db = FirebaseFirestore.instance;
final now = DateTime.now();
final totalLocations = 4;

class LocationHistoryScreen extends StatelessWidget {
  final int locationNumber;

  LocationHistoryScreen({this.locationNumber});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Location History',
              style: TextStyle(fontSize: 14.0, color: Colors.lightBlueAccent),
            ),
            SizedBox(height: 15.0),
            StreamBuilder<QuerySnapshot>(
              stream: _db
                  .collection('messages')
                  .where('location', isEqualTo: 'Location # $locationNumber')
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
                //print(messages.runtimeType);

                // array where location details will be stored
                List<LocationMessage> locationMessages = [];

                // for every document inside all documents
                for (var message in messages) {
                  //print(message.data());
                  final location = message.data()['location'];
                  final user = message.data()['user'];
                  final scannedTime = message.data()['timestamp'].toDate();
                  final approved = message.data()['approved'];
                  final address = message.data()['address'];
                  final formattedDate =
                      DateFormat.yMMMMd().add_jm().format(scannedTime);

                  final locationMessage = LocationMessage(
                    user: user.toString(),
                    location: location.toString(),
                    scannedTime: formattedDate,
                    approved: approved,
                    address: address,
                  );
                  locationMessages.add(locationMessage);
                }
                return Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    children: locationMessages,
                  ),
                );
              },
            )
          ],
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
  final String address;

  const LocationMessage(
      {this.location,
      this.user,
      this.approved,
      this.scannedTime,
      this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
//            Text(
//              '$location: ',
//              style: TextStyle(
//                  fontSize: 14.0,
//                  color: Colors.red,
//                  fontWeight: FontWeight.w700),
//            ),
            Text(
              '$scannedTime',
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
//            Text(
//              'Address ',
//              style: TextStyle(
//                  fontSize: 14.0,
//                  color: Colors.green,
//                  fontWeight: FontWeight.w700),
//            ),
            Text(
              '$address',
              style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.blue,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        SizedBox(height: 5.0),
      ],
    );
  }
}
