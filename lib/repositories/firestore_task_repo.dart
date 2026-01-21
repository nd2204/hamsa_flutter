import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/models/task/task_comment.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/models/user/user_id.dart';
import 'package:hamsa_flutter/repositories/task_repo.dart';

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

class TaskMapper {
  static Map<String, dynamic> toFirestore(TaskModel task) {
    return {
      'id': task.id.value,
      'title': task.title,
      'description': task.description,
      'createdAt': FieldValue.serverTimestamp(),
      'status': task.status.index,
      'assignees': task.assignees.map((assignee) => assignee.value).toList(),
      'comments': task.comments
          .map((comment) => comment.toFirestore())
          .toList(),
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
    );
  }
}

class FirestoreTaskRepository implements ITaskRepository {
  final FirebaseFirestore _firestore;
  static const collectionPath = "tasks";

  const FirestoreTaskRepository(FirebaseFirestore instance)
    : _firestore = instance;

  @override
  Future<void> create(TaskModel task) async {
    await _firestore
        .collection(collectionPath)
        .add(TaskMapper.toFirestore(task));
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
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

  @override
  Future<TaskModel?> findById(TaskId taskId) {
    // TODO: implement findById
    throw UnimplementedError();
  }
}
