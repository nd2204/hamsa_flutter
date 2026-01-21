import 'package:hamsa_flutter/models/user/user.dart';
import 'package:hamsa_flutter/models/user/user_id.dart';
import 'package:hamsa_flutter/repositories/user_repo.dart';
import 'package:hamsa_flutter/utils/errors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserRepository implements IUserRepository {
  final FirebaseFirestore _firestore;
  const FirestoreUserRepository(FirebaseFirestore instance)
    : _firestore = instance;

  /// Create a new user
  @override
  Future<void> create(AppUser user) async {
    return _firestore.collection('users').doc(user.id.value).set({
      'id': user.id.value,
      'email': user.email,
      'displayName': user.displayName,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isDeleted': false,
    });
  }

  @override
  Future<void> delete(UserId id) async {
    final doc = await _firestore.collection('users').doc(id.value).get();
    if (!doc.exists) {
      throw NotFoundError(message: 'User not found');
    }
    return _firestore.collection('users').doc(id.value).delete();
  }

  /// Get a user by id
  @override
  Future<AppUser?> get(UserId id) async {
    final doc = await _firestore.collection('users').doc(id.value).get();
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
    final doc = await _firestore.collection('users').doc(user.id.value).get();
    if (!doc.exists) {
      throw NotFoundError(message: 'User not found');
    }
    
    final data = doc.data()!;
    if (data['isDeleted'] == true) {
      throw NotFoundError(message: 'User has been deleted');
    }
    
    return _firestore.collection('users').doc(user.id.value).update({
      'email': user.email,
      'displayName': user.displayName,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  @override
  Future<void> markDeleted(UserId id) async {
    final doc = await _firestore.collection('users').doc(id.value).get();
    if (!doc.exists) {
      throw NotFoundError(message: 'User not found');
    }
    
    final data = doc.data()!;
    if (data['isDeleted'] == true) {
      throw StateError(message: 'User is already deleted');
    }
    
    return _firestore.collection('users').doc(id.value).update({
      'isDeleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}