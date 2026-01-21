import 'package:firebase_auth/firebase_auth.dart';
import 'package:hamsa_flutter/models/user/user.dart';
import 'package:hamsa_flutter/models/user/user_id.dart';
import 'package:hamsa_flutter/services/auth_service.dart';

class FirebaseAuthService implements IAuthService {
  final FirebaseAuth _firebaseAuth;
  const FirebaseAuthService(FirebaseAuth instance)
    : _firebaseAuth = instance;
  /// Stream of the current user
  @override
  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return AppUser(
        id: UserId(user.uid),
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        createdAt: DateTime.now(),
      );
    });
  }

  /// Sign in with email and password
  @override
  Future<AppUser> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user == null) {
        throw Exception('Failed to sign in with email and password');
      }
      return AppUser(
        id: UserId(user.uid),
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        createdAt: DateTime.now(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Sign out
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Sign up with email and password
  @override
  Future<AppUser> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw Exception('Failed to sign up with email and password');
      }
      return AppUser(
        id: UserId(user.uid),
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        createdAt: DateTime.now(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}
