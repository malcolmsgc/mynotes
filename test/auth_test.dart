import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to begin with', (() {
      expect(provider.isInitialized, false);
    }));

    test('Cannot log out if not initialized', (() {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    }));

    test('Should be able to be initialized', (() async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }));

    test('User should be null after initialization', (() {
      expect(provider.currentUser, null);
    }));

    test(
      'Should be able to initialize in < 2s',
      (() async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      }),
      timeout: const Timeout(const Duration(seconds: 2)),
    );

    test('Create user should delegate to logIn func', (() async {
      final badEmailUser = provider.createUser(
        email: 'unknown@email.com',
        password: 'password',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(
        email: 'correct@email.com',
        password: 'wrong-password',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final validUser = await provider.createUser(
        email: 'correct@email.com',
        password: 'password',
      );

      expect(provider.currentUser, validUser);
      expect(validUser.isEmailVerified, false);
    }));

    test('Logged in user should be able to get verified', (() {
      provider.sendVerificationEmail();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    }));

    test('User should be able to log out and in', (() async {
      await provider.logOut();
      await provider.logIn(
        email: 'correct@email.com',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    }));
    // END OF GROUP
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: implement initialize
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'unknown@email.com') throw UserNotFoundAuthException();
    if (password == 'wrong-password') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user == null;
  }

  @override
  Future<void> sendVerificationEmail() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
