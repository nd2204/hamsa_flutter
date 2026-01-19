import 'package:hamsa_flutter/models/user/user.dart';

abstract class IAuthRepository {
  Stream<AppUser?> get authStateChanges;
  Future<AppUser> signInWithEmailAndPassword(String email, String password);
  Future<AppUser> signUpWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}