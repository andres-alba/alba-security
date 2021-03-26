import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  String id;
  String location;
  String user;
  Timestamp createdAt;

  LocationModel({this.id, this.createdAt, this.location, this.user});
}
