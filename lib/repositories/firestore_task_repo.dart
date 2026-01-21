import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/repositories/task_repo.dart';

class FirestoreTaskRepository implements ITaskRepository {
  final FirebaseFirestore _firestore;
  static const collectionPath = "tasks";

  const FirestoreTaskRepository(FirebaseFirestore instance)
    : _firestore = instance;

  @override
  Future<void> create(TaskModel task) async {
    await _firestore.collection(collectionPath).add({});
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> getByStatus(TaskStatus status) {
    // TODO: implement getByStatus
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> list(String id) {
    // TODO: implement list
    throw UnimplementedError();
  }

  @override
  Future<void> update(TaskModel task) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Stream<List<TaskModel>> watch(String id) {
    // TODO: implement watch
    throw UnimplementedError();
  }
}
