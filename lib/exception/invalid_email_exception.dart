/// Custom exception for invalid email
class InvalidEmailException implements Exception {
  final String cause;
  InvalidEmailException(this.cause);
}