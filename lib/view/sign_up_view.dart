import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_care_tracker/controller/sign_up_controller.dart';
import 'package:hair_care_tracker/exception/nickname_taken_exception.dart';
import 'package:hair_care_tracker/exception/server_error_exception.dart';
import 'package:hair_care_tracker/exception/user_exists_exception.dart';
import 'package:hair_care_tracker/view/log_in_view.dart';

import 'home_view.dart';

/// SignUpView class. Page where we sign up new user.
class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

/// SignUpView state class. Representing state of the page.
class _SignUpViewState extends State<SignUpView> {
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();

  /// Controller of secure storage.
  final storage = new FlutterSecureStorage();

  /// Controller object of this page.
  SignUpController _signUpController = SignUpController();

  /// Variables to change visibility of password and repeatPassword.
  bool _obscureTextPassword = true;
  bool _obscureTextRepeatPassword = true;

  /// Build-in method from State<T> class.
  /// Provides text field with validation, button to sign up user and
  /// button to go to log in page.
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
                child: Text("Create an account",
                    style: GoogleFonts.lato(fontSize: 18)),
              ),
              _nicknameTextFieldBuilder(),
              _emailTextFieldBuilder(),
              _passwordTextFieldBuilder(),
              _repeatPasswordTextFieldBuilder(),
              _signUpBtnBuilder(),
              Container(
                  margin: const EdgeInsets.only(top: 5.0, left: 90, right: 90),
                  child:Divider(color: Colors.black)),
              _logInBtnBuilder(),
            ],
          ),
        )

      )
    ;
  }

  /// Method to build the nickname text field.
  /// Allows only characters, digits, dots and underscores.
  Widget _nicknameTextFieldBuilder() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 0),
      child: TextFormField(
        decoration: InputDecoration(hintText: "Nickname"),
        controller: _nicknameController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return _signUpController.validateNickname(value);
        },
        maxLength: 20,
        maxLengthEnforced: true,
        keyboardType: TextInputType.name,
        inputFormatters: [
          FilteringTextInputFormatter.allow(new RegExp("[a-zA-Z0-9._]"))
        ],
      ),
    );
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
          return _signUpController.validateEmail(value);
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
          return _signUpController.validatePassword(value);
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

  /// Method to build repeat password field.
  Widget _repeatPasswordTextFieldBuilder() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Repeat password",
          suffixIcon: _toggleRepeatPasswordVisibilityBuilder(),
        ),
        controller: _repeatPasswordController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return _signUpController.validateRepeatPassword(
              value, _passwordController.text.toString());
        },
        obscureText: _obscureTextPassword,
        enableSuggestions: false,
        autocorrect: false,
      ),
    );
  }

  /// Method to change visibility of repeat password.
  Widget _toggleRepeatPasswordVisibilityBuilder() {
    return IconButton(
      icon: Icon(
        _obscureTextRepeatPassword ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: () {
        setState(() {
          _obscureTextRepeatPassword = !_obscureTextRepeatPassword;
        });
      },
    );
  }

  /// Method to build the sign up button.
  /// Fires all validations. If they are correct signs up new user.
  /// If user is sign up correctly then it goes to the home screen.
  Widget _signUpBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 40.0, left: 80, right: 80),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              String nickname = _nicknameController.text.toString();
              String email = _emailController.text.toString();
              String password = _passwordController.text.toString();

              if (_signUpController.validateNickname(nickname) == null &&
                  _signUpController.validateEmail(email) == null &&
                  _signUpController.validatePassword(password) == null &&
                  _signUpController.validateRepeatPassword(
                          _repeatPasswordController.text.toString(),
                          password) ==
                      null) {
                try {
                  String token = await _signUpController.signUp(nickname, email, password);
                  await storage.write(key: "token", value: token);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeView()),
                      (route) => false);
                } on ServerErrorException {
                  Fluttertoast.showToast(
                      msg: "Internal error. Please try again",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } on UserExistsException {
                  Fluttertoast.showToast(
                      msg: "User with the same email exists. Try logging in.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } on NicknameTakenException {
                  Fluttertoast.showToast(
                      msg: "Nickname is taken, try different one.",
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
            child: Text("Sign up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          ),
        ));
  }

  /// Method to build log in button.
  /// Goes to the Log in page.
  Widget _logInBtnBuilder() {
    return Container(margin: const EdgeInsets.only(top: 5.0, left: 80, right: 80),
      child: SizedBox(
          width: double.infinity,
      child: ElevatedButton(
        child: Text("Log in",  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LogInView()));
        },
      ),)
    );
  }

  /// Build-in method to free up resources when view is not visible.
  @override
  void dispose() {
    super.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
  }
}
