import 'package:email_validator/email_validator.dart';
import 'package:hair_care_tracker/exception/nickname_taken_exception.dart';
import 'package:hair_care_tracker/exception/server_error_exception.dart';
import 'package:hair_care_tracker/exception/user_exists_exception.dart';
import 'package:hair_care_tracker/service/hash_service.dart';
import 'package:hair_care_tracker/service/security_service.dart';

/// Controller class of sign up page.
/// Provides validators for all fields and sign up method to handle api request.
class SignUpController {
  SecurityService securityService = SecurityService();

  /// Method to validate nickname.
  /// Checks if [value] is empty or exceeds 20 character length.
  String validateNickname(String value) {
    if (value.isEmpty) {
      return "Please, enter your nickname.";
    } else if (value.length > 20) {
      return "Your nickname is too long.";
    }
    return null;
  }

  /// Method to validate email.
  /// Checks if [value] is empty or if is valid using EmailValidator plugin.
  String validateEmail(String value) {
    if (value.isEmpty) {
      return "Please, enter your email.";
    } else if (!EmailValidator.validate(value)) {
      return "Email is incorrect";
    }
    return null;
  }

  /// Method to validate password.
  /// Check if [value] is empty or matches the regular expression for strong
  /// password.
  String validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,40}$';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "Please, enter your password.";
    } else if (!regExp.hasMatch(value)) {
      return "Incorrect password";
    }
    return null;
  }

  /// Method to validate repeated password.
  /// Checks if [rPassword] is empty or if it is the same as [password].
  String validateRepeatPassword(String rPassword, String password) {
    if (rPassword.isEmpty) {
      return "Please, enter your password.";
    } else if (password == null || rPassword != password) {
      return "Passwords are not identical";
    }
    return null;
  }

  /// Method to handle API request to add new user.
  Future<String> signUp(String nickname, String email, String password) async {
    // Encrypt password
    String hashedPassword = HashService.hashPassword(password);
    // Make API request
    String token = await securityService.signUpRequest(
        nickname, email, hashedPassword);
    if (token ==
        null) { // Something went wrong with the server, we don't know what.
      throw ServerErrorException("Server side error");
    } else if (token == "User exists") {
      throw UserExistsException(token);
    } else if (token == "Nickname taken") {
      throw NicknameTakenException(token);
    } else {
      // Return token to be written to the storage.
      return token;
    }
  }
}
