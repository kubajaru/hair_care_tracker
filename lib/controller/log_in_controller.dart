import 'package:hair_care_tracker/exception/incorrect_password_exception.dart';
import 'package:hair_care_tracker/exception/invalid_email_exception.dart';
import 'package:hair_care_tracker/exception/server_error_exception.dart';
import 'package:hair_care_tracker/service/hash_service.dart';
import 'package:hair_care_tracker/service/security_service.dart';

/// Controller class of log in page.
class LogInController {
  SecurityService securityService = SecurityService();

  /// Method to handle API request to log in a user.
  Future<String> logIn(String email, String password) async {
    // Encrypt password.
    String hashedPassword = HashService.hashPassword(password);
    // Make API request.
    String token = await securityService.logInRequest(email, hashedPassword);
    if (token == null) { // Something went wrong with the server, we don't know what.
      throw ServerErrorException("Server side error");
    } else if (token == '') {
      throw IncorrectPasswordException("Password is incorrect");
    } else if (token == "Invalid email") {
      throw InvalidEmailException("Email does not exist");
    } else {
      // Return token to be written to the storage.
      return token;
    }
  }
}