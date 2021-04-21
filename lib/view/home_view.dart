import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_care_tracker/view/my_products_view.dart';
import 'package:hair_care_tracker/view/profile_view.dart';
import 'package:hair_care_tracker/view/sign_up_view.dart';

import 'calendar_view.dart';

/// HomeView class. Here you can launch all functionality of our application
/// as well as log out from the app.
class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

/// HomeView state class. Representing state of the page.
class _HomeViewState extends State<HomeView> {
  /// Controller of secure storage.
  final storage = new FlutterSecureStorage();

  /// Build-in method from State<T> class.
  /// Provides buttons to launch different functionality.
  /// Return our page view as Widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hair Care Tracker", style: GoogleFonts.lato()),
        ),
        body: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Text("Home", style: GoogleFonts.lato(fontSize: 28)),
          ),
          _profileBtnBuilder(),
          _calendarBtnBuilder(),
          _myProductsBtnBuilder(),
          _logOutBtnBuilder(),
        ]));
  }

  /// Method to build Profile button.
  /// Goes to the Profile page.
  Widget _profileBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 20.0, left: 60, right: 60),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              child: Text(
                "My hair profile",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileView()));
              }),
        ));
  }

  /// Method to build Calendar button.
  /// Goes to the Calendar page.
  Widget _calendarBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 15.0, left: 60, right: 60),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              child: Text(
                "Calendar of routines",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CalendarView()));
              }),
        ));
  }

  /// Method to build My products button.
  /// Goes to the My products page.
  Widget _myProductsBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 15.0, left: 60, right: 60),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              child: Text(
                "My products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyProductsView()));
              }),
        ));
  }

  /// Method to build Log out button.
  /// Goes to the Sign Up page.
  Widget _logOutBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 40.0, left: 60, right: 60),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              child: Text(
                "Log out",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              onPressed: () async {
                await storage.delete(key: "token");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpView()),
                    (route) => false);
              }),
        ));
  }
}
