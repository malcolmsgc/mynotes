import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // showErrorDialog(context, 'The password provided is too weak.',
        //     "Registration error:");
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        // showErrorDialog(context, 'An account already exists for that email.',
        //     "Registration error:");
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        // showErrorDialog(context, 'An account already exists for that email.',
        //     "Registration error:");
        throw AuthException();
        // throw InvalidEmailException();
      } else {
        throw AuthException();
      }
    } catch (e) {
      throw AuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
        // await showErrorDialog(
        //     context, 'No user found for that email.', 'Log in error');
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
        // await showErrorDialog(
        //     context, 'Wrong password provided for that user.', 'Log in error');
      } else {
        throw AuthException();
        // await showErrorDialog(context, e.message.toString(), 'Log in error');
      }
    } catch (e) {
      throw AuthException();
      // await showErrorDialog(context, e.toString(), 'Log in error');
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
