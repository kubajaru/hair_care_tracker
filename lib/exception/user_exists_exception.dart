/// Custom exception for user exists
class UserExistsException implements Exception {
  final String cause;
  UserExistsException(this.cause);
}