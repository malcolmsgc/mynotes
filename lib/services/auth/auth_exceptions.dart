// Login exceptions

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// Registration exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

// Generic exceptions

class AuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
