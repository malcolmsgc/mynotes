// Generic exceptions

class AuthException implements Exception {
  final String? msg;

  String get message => msg.toString();

  AuthException([this.msg = ""]);
}

class UserNotLoggedInAuthException implements Exception {}

// Login exceptions

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// Registration exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}
