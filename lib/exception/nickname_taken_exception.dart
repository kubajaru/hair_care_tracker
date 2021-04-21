/// Custom exception for nickname that is taken
class NicknameTakenException implements Exception {
  final String cause;
  NicknameTakenException(this.cause);
}