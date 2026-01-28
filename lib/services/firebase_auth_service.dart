import 'package:firebase_auth/firebase_auth.dart';
import 'package:hamsa_flutter/models/user/user.dart';
import 'package:hamsa_flutter/models/user/user_id.dart';
import 'package:hamsa_flutter/services/auth_service.dart';
import 'package:hamsa_flutter/repositories/user_repo.dart';
import 'package:hamsa_flutter/utils/injectable.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IAuthService)
class FirebaseAuthService implements IAuthService {
  final FirebaseAuth _firebaseAuth;
  final IUserRepository _userRepository;

  FirebaseAuthService()
    : _firebaseAuth = FirebaseAuth.instance,
      _userRepository = getIt<IUserRepository>();

  /// Stream of the current user
  @override
  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      // Lấy user từ repository để có đầy đủ thông tin bao gồm isDeleted
      final appUser = await _userRepository.get(UserId(user.uid));

      // FIX: When signing up,
      // the service might not have added the user to the database
      // and thus return the appUser = null
      if (appUser == null || appUser.isDeleted) {
        await _firebaseAuth.signOut();
        return null;
      }

      return appUser;
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

      // Lấy user từ repository để có đầy đủ thông tin bao gồm isDeleted
      final appUser = await _userRepository.get(UserId(user.uid));
      if (appUser == null) {
        throw Exception('User not found');
      }

      if (appUser.isDeleted) {
        await _firebaseAuth.signOut();
        throw Exception('Tài khoản đã bị xóa');
      }

      return appUser;
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
    String displayName,
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

      final appUser = AppUser(
        id: UserId(user.uid),
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
      );

      // Tự động tạo user trong Firestore khi đăng ký
      await _userRepository.create(appUser);

      return appUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}
