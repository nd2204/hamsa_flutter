import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:hamsa_flutter/repositories/firestore_user_repo.dart';
import 'package:hamsa_flutter/repositories/user_repo.dart';
import 'package:hamsa_flutter/services/firebase_auth_service.dart';
import 'package:hamsa_flutter/services/auth_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Repositories
  getIt.registerLazySingleton<IUserRepository>(
    () => FirestoreUserRepository(FirebaseFirestore.instance),
  );

  // Services
  getIt.registerLazySingleton<IAuthService>(
    () => FirebaseAuthService(FirebaseAuth.instance, getIt<IUserRepository>()),
  );
}
