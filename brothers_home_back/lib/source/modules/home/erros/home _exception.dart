import 'dart:convert';

class HomeException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  final int statusCode;

  HomeException(this.statusCode, this.message, [this.stackTrace]);

  String toJson() {
    return jsonEncode({'error': message});
  }

  @override
  String toString() => 'UserException(message: $message, stackTrace: $stackTrace, statusCode: $statusCode)';
}
