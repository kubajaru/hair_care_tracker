import 'package:flutter/material.dart';
import 'view/start_view.dart';

/// Function to start our application.
void main() {
  runApp(EntryPoint());
}

/// Entry point of our application.
class EntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hair Care Tracker',
      theme: ThemeData(
        primaryColor: Colors.pink.shade300,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.purple.shade300,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StartView(), // First page of our application
    );
  }
}

