/// Custom exception for server error
class ServerErrorException implements Exception {
  final String cause;
  ServerErrorException(this.cause);
}