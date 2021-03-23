import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'scan_screen.dart';
import 'package:provider/provider.dart';

User loggedInUser;
int index = 0;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

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
        body: PageView(
          onPageChanged: _onPageChanged,
          controller: _pageController,
          children: _screens,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
              ),
              title: Text(
                'Scan',
                style: TextStyle(
                  color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.verified_user,
                color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
              ),
              title: Text(
                'Profile',
                style: TextStyle(
                  color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ],
        ));
  }
}
