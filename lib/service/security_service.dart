import 'dart:convert';


import 'package:http/http.dart' show Client;

/// Service to make API request for logIn and SignUp.
class SecurityService {
  Client client = Client();
  /// Method to make POST request to /login endpoint to get JWT token.
  Future<String> logInRequest(String email, String hashedPassword) async {
    var url = Uri.parse('http://10.0.0.34:8080/login'); // Address + endpoint
    Map data = {
      "email": email,
      "password": hashedPassword
    };
    String body = json.encode(data); // JSON object with email and password.
    var response = await client.post(url, headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) { // 200 == we are good to go.
      return response.body;
    } else if (response.statusCode == 400) { // invalid email
      return "Invalid email";
    }
    return null;
  }

  /// Method to make POST request to /signup endpoint to get JWT token.
  Future<String> signUpRequest(String nickname, String email, String hashedPassword) async {
    var url = Uri.parse('http://10.0.0.34:8080/signup');
    Map data = {
      "nickname": nickname,
      "email": email,
      "password": hashedPassword
    };
    String body = json.encode(data); // JSON object with nickname, email and password.
    var response = await client.post(url, headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) { // 200 == we are good to go.
      return response.body;
    } else if (response.statusCode == 400) { // user exists
      return "User exists";
    } else if (response.statusCode == 409) { // nickname taken
      return "Nickname taken";
    }
    return null;
  }
}