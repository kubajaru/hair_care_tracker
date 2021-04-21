import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_care_tracker/controller/profile_controller.dart';
import 'package:hair_care_tracker/model/profile.dart';
import 'package:hair_care_tracker/view/home_view.dart';

/// ProfileView class. Here you can update your hair profile.
class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

/// ProfileView state class. Representing state of the page.
class _ProfileViewState extends State<ProfileView> {
  TextEditingController _ageController = TextEditingController();
  TextEditingController _lengthController = TextEditingController();
  TextEditingController _problemsController = TextEditingController();

  /// Controller of secure storage.
  final storage = new FlutterSecureStorage();

  /// Controller object of this page.
  ProfileController _profileController = ProfileController();

  /// Variables for dropdown buttons.
  String porosity;
  String curlType;
  String thickness;
  String denseness;
  String state;

  /// Build-in method to initialize the page with values from the database if
  /// the profile already exists.
  @override
  void initState() {
    super.initState();
    initialize();
  }

  /// initState cannot be async so we pulled it all to separate method
  void initialize() async {
    String token = await storage.read(key: "token");
    Profile profile = await _profileController.getProfile(token);
    if (profile != null) {
      setState(() {
        _ageController.text = profile.age;
        _lengthController.text = profile.length;
        _problemsController.text = profile.problems;
        porosity = profile.porosity;
        state = profile.state;
        curlType = profile.curlType;
        thickness = profile.thickness;
        denseness = profile.denseness;
      });
    }
  }

  /// Build-in method from State<T> class.
  /// Provides text fields with validations, dropdown buttons, save button to
  /// update profile and discard button to discard changes.
  /// Return our page view as Widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hair Care Tracker", style: GoogleFonts.lato()),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child:
                Text("My hair profile", style: GoogleFonts.lato(fontSize: 18)),
              ),
              _ageTextFieldBuilder(),
              _lengthTextFieldBuilder(),
              _porosityDropdownBtnBuilder(),
              _stateDropdownBtnBuilder(),
              _curlTypeDropdownBtnBuilder(),
              _thicknessDropdownBtnBuilder(),
              _densenessDropdownBtnBuilder(),
              _problemsTextFieldBuilder(),
              _saveBtnBuilder(),
              Container(
                  margin: const EdgeInsets.only(
                      top: 5.0, left: 100, right: 100),
                  child: Divider(color: Colors.black)),
              _discardBtnBuilder(),
            ])));
  }

  /// Method to build the age text field.
  /// Allows only numbers in certain range which is from 10 to 99.
  Widget _ageTextFieldBuilder() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, left: 20, right: 20, bottom: 0),
      child: TextFormField(
        decoration: InputDecoration(hintText: "Your age"),
        controller: _ageController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return _profileController.validateAge(value);
        },
        maxLength: 2,
        maxLengthEnforced: true,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
        ],
      ),
    );
  }

  /// Method to build the length text field.
  /// Allows only numbers in certain range which is from 0 to 999.
  Widget _lengthTextFieldBuilder() {
    return Container(
      margin: const EdgeInsets.only(top: 0.0, left: 20, right: 20, bottom: 0),
      child: TextFormField(
        decoration:
        InputDecoration(hintText: "Length of hair", suffixText: "cm"),
        controller: _lengthController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value.isEmpty) {
            return "This field cannot be empty!";
          }
          return null;
        },
        maxLength: 3,
        maxLengthEnforced: true,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(new RegExp("[0-9]"))
        ],
      ),
    );
  }

  /// Method to build dropdown porosity button.
  /// Current value of button is stored in [porosity] field.
  Widget _porosityDropdownBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 0.0, left: 20, right: 20, bottom: 0),
        child: SizedBox(
          width: double.infinity,
          child: DropdownButton(
            // Hint works only if [porosity] starts as null.
            hint: Text("Porosity"),
            value: porosity,
            // Must be true to have icon on the far right.
            isExpanded: true,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            underline: Container(
              height: 2,
              color: Colors.pink.shade300,
            ),
            onChanged: (String newValue) {
              setState(() {
                porosity = newValue;
              });
            },
            items: <String>['Low', 'Medium', 'High']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ));
  }

  /// Method to build dropdown state button.
  /// Current value of button is stored in [state] field.
  Widget _stateDropdownBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 5.0, left: 20, right: 20, bottom: 0),
        child: SizedBox(
          width: double.infinity,
          child: DropdownButton(
            // Hint works only if [porosity] starts as null.
            hint: Text("Natural/Dyed/Bleached"),
            value: state,
            // Must be true to have icon on the far right.
            isExpanded: true,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            underline: Container(
              height: 2,
              color: Colors.pink.shade300,
            ),
            onChanged: (String newValue) {
              setState(() {
                state = newValue;
              });
            },
            items: <String>['Natural', 'Dyed', 'Bleached']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ));
  }

  /// Method to build dropdown curlType button.
  /// Current value of button is stored in [curlType] field.
  Widget _curlTypeDropdownBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 5.0, left: 20, right: 20, bottom: 0),
        child: SizedBox(
          width: double.infinity,
          child: DropdownButton(
            // Hint works only if [porosity] starts as null.
            hint: Text("Type of curl"),
            value: curlType,
            // Must be true to have icon on the far right.
            isExpanded: true,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            underline: Container(
              height: 2,
              color: Colors.pink.shade300,
            ),
            onChanged: (String newValue) {
              setState(() {
                curlType = newValue;
              });
            },
            items: <String>[
              '1',
              '2a',
              '2b',
              '2c',
              '3a',
              '3b',
              '3c',
              '4a',
              '4b',
              '4c'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ));
  }

  /// Method to build dropdown thickness button.
  /// Current value of button is stored in [thickness] field.
  Widget _thicknessDropdownBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 5.0, left: 20, right: 20, bottom: 0),
        child: SizedBox(
          width: double.infinity,
          child: DropdownButton(
            // Hint works only if [porosity] starts as null.
            hint: Text("Thickness"),
            value: thickness,
            // Must be true to have icon on the far right.
            isExpanded: true,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            underline: Container(
              height: 2,
              color: Colors.pink.shade300,
            ),
            onChanged: (String newValue) {
              setState(() {
                thickness = newValue;
              });
            },
            items: <String>['Fine', 'Medium', 'Thick']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ));
  }

  /// Method to build dropdown denseness button.
  /// Current value of button is stored in [denseness] field.
  Widget _densenessDropdownBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 5.0, left: 20, right: 20, bottom: 0),
        child: SizedBox(
          width: double.infinity,
          child: DropdownButton(
            // Hint works only if [porosity] starts as null.
            hint: Text("Denseness"),
            value: denseness,
            // Must be true to have icon on the far right.
            isExpanded: true,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            underline: Container(
              height: 2,
              color: Colors.pink.shade300,
            ),
            onChanged: (String newValue) {
              setState(() {
                denseness = newValue;
              });
            },
            items: <String>['Thinning', 'Medium', 'Thick']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ));
  }


  /// Method to build the problems text field.
  /// Allows lower, upper case characters, digits, coma, dot and space.
  /// Limit of characters is set to 300.
  Widget _problemsTextFieldBuilder() {
    return Container(
      margin: const EdgeInsets.only(top: 0.0, left: 20, right: 20, bottom: 0),
      child: TextFormField(
        decoration: InputDecoration(
            hintText: "Describe problems with your hair and scalp."),
        controller: _problemsController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return null;
        },
        minLines: 2,
        maxLines: 6,
        maxLength: 300,
        keyboardType: TextInputType.multiline,
        maxLengthEnforced: true,
        inputFormatters: [
          FilteringTextInputFormatter.allow(new RegExp("[a-zA-Z0-9,. ]"))
        ],
      ),
    );
  }

  /// Method to build Save button.
  /// Checks if all fields beside the problems are not empty and goes to the
  /// Home page after saving changes.
  Widget _saveBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 20.0, left: 80, right: 80),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              child: Text(
                "Save",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              onPressed: () async {
                if (_ageController.text.isNotEmpty &&
                    _lengthController.text.isNotEmpty &&
                    porosity != null &&
                    curlType != null &&
                    thickness != null &&
                    denseness != null) {
                  Profile profile = Profile(
                      _ageController.text.toString(),
                      _lengthController.text.toString(),
                      porosity,
                      state,
                      curlType,
                      thickness,
                      denseness,
                      _problemsController.text.toString());
                  try {
                   String token = await storage.read(key: "token");
                    _profileController.saveProfile(profile, token);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeView()),
                            (route) => false);
                  } catch (e) {
                    log("Error $e");
                  }
                }
              }),
        ));
  }

  /// Method to build Discard button.
  /// Goes to the Home page without saving any changes.
  Widget _discardBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(
            top: 5.0, left: 80, right: 80, bottom: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              child: Text(
                "Discard",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeView()),
                        (route) => false);
              }),
        ));
  }

  /// Build-in method to free up resources when view is not visible.
  @override
  void dispose() {
    super.dispose();
    _lengthController.dispose();
    _ageController.dispose();
    _problemsController.dispose();
  }
}
