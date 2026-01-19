import 'package:hamsa_flutter/models/user/user.dart';
import 'package:hamsa_flutter/repositories/auth_repo.dart';

class FirebaseAuthService implements IAuthRepository {
  @override
  // TODO: implement authStateChanges
  Stream<AppUser?> get authStateChanges => throw UnimplementedError();

  @override
  Future<AppUser> signInWithEmailAndPassword(String email, String password) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<AppUser> signUpWithEmailAndPassword(String email, String password) {
    // TODO: implement signUpWithEmailAndPassword
    throw UnimplementedError();
  }
}
