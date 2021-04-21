/// Custom exception for incorrect password
class IncorrectPasswordException implements Exception {
  final String cause;
  IncorrectPasswordException(this.cause);
}