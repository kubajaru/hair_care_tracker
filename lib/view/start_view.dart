import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hair_care_tracker/view/home_view.dart';
import 'package:hair_care_tracker/view/sign_up_view.dart';

/// StartView class. First screen of the application with our logo
/// Here we check if our token is valid or if we have to log in to app.
class StartView extends StatefulWidget {
  @override
  _StartViewState createState() => _StartViewState();
}

/// StartView state class. Representing state of the page.
class _StartViewState extends State<StartView> {
  /// Controller of secure storage.
  final storage = new FlutterSecureStorage();

  /// Build-in method from State<T> class.
  /// Provides our logo.
  /// Return our page view as Widget.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo.png'),
            fit: BoxFit.cover,
          )),
    );
  }

  /// Build-in function. Fired when the page is loaded.
  /// Here we will decide if we should go to home page of sign up page.
  @override
  void initState() {
    super.initState();
    chooseScreen();
  }

  /// Method to read the key from the storage and act appropriately.
  void chooseScreen() async {
    String token = await storage.read(key: "token");
    if (token == null) { // User not logged in. Go to sign up view.
      Timer timer = new Timer(Duration(seconds: 3), () => {
      Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignUpView()),
      (route) => false)
      });
    } else { // User logged in. Go to home view.
      Timer timer = new Timer(Duration(seconds: 3), () => {
      Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeView()),
      (route) => false)
      });
    }
  }
}
