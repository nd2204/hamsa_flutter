import 'package:hamsa_flutter/models/user/user.dart';

abstract class IAuthService {
  Stream<AppUser?> get authStateChanges;
  Future<AppUser> signInWithEmailAndPassword(String email, String password);
  Future<AppUser> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  );
  Future<void> signOut();
}
