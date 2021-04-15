import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class ScanController extends GetxController {
  final userName = "".obs;
  String name = "";
  var displayNameFirestore;

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
}
