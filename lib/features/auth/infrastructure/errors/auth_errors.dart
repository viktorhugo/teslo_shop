class WrongCredentials implements Exception {}
class InvalidToken implements Exception {}
class ConnectionTimeout implements Exception {}

class CustomError implements Exception {
  final String message;
  final bool? logRequired;

  CustomError({
    required this.message,
    this.logRequired = false
  });
}