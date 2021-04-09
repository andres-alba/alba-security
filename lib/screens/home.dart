import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'category_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'scan_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_screen.dart';

int index = 0;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //bottom nav stuff
  PageController _pageController = PageController();

  List<Widget> _screens = [
    ScanScreen(),
    ProfileScreen(),
  ];

  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, LoginScreen.id);
              }),
        ],
        title: Text(
          'Welcome ${_auth.currentUser.email}!',
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('users')
            .doc(_auth.currentUser.uid)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: LinearProgressIndicator());
          }
          final userData = snapshot.data.data();
          if (userData['role'] == 'admin') {
            return AdminScreen();
          }
          return CategoryScreen();
        },
      ),
    );
  }
}
