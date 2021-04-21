import 'dart:convert';
import 'dart:developer';

import 'package:hair_care_tracker/model/profile.dart';
import 'package:hair_care_tracker/service/profile_service.dart';

/// Class of profile page controller.
class ProfileController{

  ProfileService service = ProfileService();

  /// Method to validate the [age]. Checks if it is not empty and if the [iAge]
  /// is greater then 10.
  String validateAge(String age){
    if(age.isNotEmpty){
      int iAge = int.parse(age);
      if(iAge<10){
        return "Your age must be between 10 and 99!";
      }
    } else {return "This field cannot be empty!";}
    return null;
  }

  /// Method to get profile from API if it exists.
  Future<Profile> getProfile(String token) async {
    String jsonString = await service.getProfile(token);
    if (jsonString == "Server error") {
      return null;
    } else if (jsonString == null) {
      return null;
    } else {
      Map json = jsonDecode(jsonString);
      Profile profile = Profile.fromJson(json);
      return profile;
    }
  }

  /// Method to save changes to the API.
  void saveProfile(Profile profile, String token) async {
    String json = jsonEncode(profile);
    service.putProfile(json, token);
  }
}