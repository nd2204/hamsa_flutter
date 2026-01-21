import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/models/task/task_comment.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/models/user/user_id.dart';
import 'package:hamsa_flutter/repositories/task_repo.dart';
import 'package:hamsa_flutter/utils/errors.dart';

class FirestoreTaskRepository implements ITaskRepository {
  final FirebaseFirestore _firestore;
  static const collectionPath = "tasks";

  const FirestoreTaskRepository(FirebaseFirestore instance)
    : _firestore = instance;

  @override
  Future<void> create(TaskModel task) async {
    await _firestore
        .collection(collectionPath)
        .doc(task.id.value)
        .set(task.toFirestore());
  }

  @override
  Future<void> delete(TaskId taskId) async {
    final doc = await _firestore
        .collection(collectionPath)
        .doc(taskId.value)
        .get();
    if (!doc.exists) {
      throw NotFoundError(message: 'Cannot found task with id=${taskId.value}');
    }
    doc.reference.delete();
  }

  @override
  Future<void> markDeleted(TaskId taskId, [bool value = true]) async {
    final doc = await _firestore
        .collection(collectionPath)
        .doc(taskId.value)
        .get();
    if (!doc.exists) {
      throw NotFoundError(message: 'Cannot found task with id=${taskId.value}');
    }
    doc.reference.update({'deleted': value});
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

  @override
  Future<TaskModel?> findById(TaskId taskId) async {
    final doc = await _firestore
        .collection(collectionPath)
        .doc(taskId.value)
        .get();
    if (!doc.exists) return null;
    return TaskMapper.fromFirestore(doc);
  }
}

extension TaskCommentMapper on TaskComment {
  Map<String, dynamic> toFirestore() {
    return {'ownerId': ownerId, 'text': text, 'createdAt': createdAt};
  }

  static TaskComment fromFirestore(Map<String, dynamic> data) {
    return TaskComment(
      ownerId: data['ownerId'],
      text: data['text'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}

extension TaskMapper on TaskModel {
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'status': status.index,
      'assignees': assignees.map((assignee) => assignee.value).toList(),
      'comments': comments.map((comment) => comment.toFirestore()).toList(),
      'deleted': deleted,
    };
  }

  static TaskModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final assignees = List<String>.from(data['assignees']);
    final comments = List<Map<String, dynamic>>.from(data['comments']);

    return TaskModel(
      id: TaskId.from(doc.id),
      title: data['title'],
      description: data['description'],
      assignees: assignees.map((value) => UserId(value)).toSet(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),

      // WARN: fetching comments can be expensive
      // TODO: find another way to fetch comments separately
      comments: comments
          .map((comment) => TaskCommentMapper.fromFirestore(comment))
          .toList(),

      status: TaskStatus.fromInt(data['status']),
      deleted: data['deleted'],
    );
  }
}
