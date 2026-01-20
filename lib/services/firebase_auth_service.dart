import 'package:firebase_auth/firebase_auth.dart';
import 'package:hamsa_flutter/models/user/user.dart';
import 'package:hamsa_flutter/repositories/auth_repo.dart';

class FirebaseAuthService implements IAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  

  /// Stream of the current user
  @override
  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user){
      if(user == null) return null;
      return AppUser(
        id: user.uid,
        email: user.email ?? '',
      );
    });
  }

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
