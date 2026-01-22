import 'package:hamsa_flutter/models/user/user.dart';
import 'package:hamsa_flutter/models/user/user_id.dart';
import 'package:hamsa_flutter/repositories/user_repo.dart';
import 'package:hamsa_flutter/utils/errors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFieldLabel {
  static const id = 'id';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
  static const email = 'email';
  static const displayName = 'displayName';
  static const isDeleted = 'isDeleted';
}

extension UserFieldExtractor on DocumentSnapshot {
  UserId get uid => UserId(UserFieldLabel.id);
  DateTime get createdAt => get(UserFieldLabel.createdAt);
  DateTime get updatedAt => get(UserFieldLabel.updatedAt);
  String get email => get(UserFieldLabel.email);
  String get displayName => get(UserFieldLabel.displayName);
  bool get isDeleted => get(UserFieldLabel.isDeleted);
}

class UserMapper {
  static AppUser fromFirestore(DocumentSnapshot doc) {
    return AppUser(
      id: doc.uid,
      createdAt: doc.createdAt,
      email: doc.email,
      displayName: doc.displayName,
    );
  }

  static Map<String, dynamic> toFirestore(AppUser user) {
    return {
      'id': user.id.value,
      'email': user.email,
      'displayName': user.displayName,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isDeleted': false,
    };
  }
}

class FirestoreUserRepository implements IUserRepository {
  final FirebaseFirestore _firestore;
  static const String collectionPath = 'users';

  const FirestoreUserRepository(FirebaseFirestore instance)
    : _firestore = instance;

  /// Create a new user
  @override
  Future<void> create(AppUser user) async {
    return _firestore
        .collection(collectionPath)
        .doc(user.id.value)
        .set(UserMapper.toFirestore(user));
  }

  @override
  Future<void> delete(UserId id) async {
    final doc = await _firestore.collection(collectionPath).doc(id.value).get();
    if (!doc.exists) {
      throw NotFoundError(message: 'User not found');
    }
    return _firestore.collection(collectionPath).doc(id.value).delete();
  }

  /// Get a user by id
  @override
  Future<AppUser?> get(UserId id) async {
    final doc = await _firestore.collection(collectionPath).doc(id.value).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    if (data['isDeleted'] == true) return null;

    return AppUser(
      id: UserId(data['id']),
      email: data['email'],
      displayName: data['displayName'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Update a user
  @override
  Future<void> update(AppUser user) async {
    final doc = await _firestore
        .collection(collectionPath)
        .doc(user.id.value)
        .get();

    if (!doc.exists) {
      throw NotFoundError(message: 'User not found');
    }

    if (doc.isDeleted) {
      throw NotFoundError(message: 'User has been deleted');
    }

    return _firestore.collection(collectionPath).doc(user.id.value).update({
      UserFieldLabel.email: user.email,
      UserFieldLabel.displayName: user.displayName,
      UserFieldLabel.updatedAt: FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> markDeleted(UserId id) async {
    final doc = await _firestore.collection(collectionPath).doc(id.value).get();
    if (!doc.exists) {
      throw NotFoundError(message: 'User not found');
    }

    if (doc.isDeleted) {
      throw StateError(message: 'User is already deleted');
    }

    return _firestore.collection(collectionPath).doc(id.value).update({
      UserFieldLabel.isDeleted: true,
      UserFieldLabel.updatedAt: FieldValue.serverTimestamp(),
    });
  }
}
