import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_care_tracker/controller/log_in_controller.dart';
import 'package:hair_care_tracker/exception/incorrect_password_exception.dart';
import 'package:hair_care_tracker/exception/invalid_email_exception.dart';
import 'package:hair_care_tracker/exception/server_error_exception.dart';
import 'home_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// LogInView class. Here you can log in user if it has an account.
class LogInView extends StatefulWidget {
  @override
  _LogInViewState createState() => _LogInViewState();
}

/// LogInView state class. Representing state of the page.
class _LogInViewState extends State<LogInView> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  /// Controller object of this page.
  LogInController _logInController = LogInController();

  /// Controller of secure storage.
  final storage = new FlutterSecureStorage();

  /// Variable to change visibility of password.
  bool _obscureTextPassword = true;

  /// Build-in method from State<T> class.
  /// Provides text fields with validation and button to log in user.
  /// Return our page view as Widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hair Care Tracker", style: GoogleFonts.lato()),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: Text("Log in", style: GoogleFonts.lato(fontSize: 18)),
              ),
              _emailTextFieldBuilder(),
              _passwordTextFieldBuilder(),
              _logInBtnBuilder(),
            ],
          ),
        ));
  }

  /// Method to build the email text field.
  Widget _emailTextFieldBuilder() {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 20, right: 20),
      child: TextFormField(
        decoration: InputDecoration(hintText: "Email"),
        controller: _emailController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value.isEmpty) {
            return "Email field cannot be empty!";
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  /// Method to build the password field.
  Widget _passwordTextFieldBuilder() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Password",
          suffixIcon: _togglePasswordVisibilityBuilder(),
        ),
        controller: _passwordController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value.isEmpty) {
            return "Password field cannot be empty!";
          }
          return null;
        },
        obscureText: _obscureTextPassword,
        enableSuggestions: false,
        autocorrect: false,
      ),
    );
  }

  /// Method to change visibility of password.
  Widget _togglePasswordVisibilityBuilder() {
    return IconButton(
      icon: Icon(
        _obscureTextPassword ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: () {
        setState(() {
          _obscureTextPassword = !_obscureTextPassword;
        });
      },
    );
  }

  /// Method to build log in button.
  /// Goes to the Home page if log in is successful.
  Widget _logInBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 40.0, left: 80, right: 80),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text("Log in",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            onPressed: () async {
              String email = _emailController.text.toString();
              String password = _passwordController.text.toString();
              if (email.isNotEmpty && password.isNotEmpty) {
                try {
                  String token = await _logInController.logIn(email, password);
                  await storage.write(key: "token", value: token);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeView()),
                      (route) => false);
                } on ServerErrorException {
                  log("Server side exception");
                  Fluttertoast.showToast(
                      msg: "Internal error. Please try again",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } on IncorrectPasswordException {
                  log("Invalid password exception");
                  Fluttertoast.showToast(
                      msg: "Incorrect password. Please try again",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } on InvalidEmailException {
                  log("Invalid email exception");
                  Fluttertoast.showToast(
                      msg: "Incorrect email. Please try again",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } catch (e) {
                  log("Error $e");
                }
              }
            },
          ),
        ));
  }

  /// Build-in method to free up resources when view is not visible.
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
