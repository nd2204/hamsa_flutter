import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamsa_flutter/models/task/repeat_cycle.dart';
import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/models/task/task_comment.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/models/user/user_id.dart';
import 'package:hamsa_flutter/repositories/task_repo.dart';
import 'package:hamsa_flutter/utils/errors.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ITaskRepository)
class FirestoreTaskRepository implements ITaskRepository {
  final FirebaseFirestore _firestore;
  static const collectionPath = "tasks";

  FirestoreTaskRepository() : _firestore = FirebaseFirestore.instance;

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
  Future<List<TaskModel>> listByStatus(
    TaskStatus status, {
    bool newestFirst = true,
  }) async {
    final query = await _firestore
        .collection(collectionPath)
        .where('status', isEqualTo: status.index)
        .orderBy('createdAt', descending: newestFirst)
        .get();
    return query.docs.map((doc) => TaskMapper.fromFirestore(doc)).toList();
  }

  @override
  Future<List<TaskModel>> listAll({bool newestFirst = true}) async {
    final snapshot = await _firestore
        .collection(collectionPath)
        .orderBy('createdAt', descending: newestFirst)
        .get();
    return snapshot.docs.map((doc) => TaskMapper.fromFirestore(doc)).toList();
  }

  @override
  Future<List<TaskModel>> listAllAvailable({bool newestFirst = true}) async {
    final snapshot = await _firestore
        .collection(collectionPath)
        .where('deleted', isEqualTo: false)
        .orderBy('createdAt', descending: newestFirst)
        .get();
    return snapshot.docs.map((doc) => TaskMapper.fromFirestore(doc)).toList();
  }

  @override
  Future<void> save(TaskModel task) async {
    final doc = await _firestore
        .collection(collectionPath)
        .doc(task.id.value)
        .get();
    if (!doc.exists) {
      throw NotFoundError(message: 'Cannot found task with ${task.id}');
    }
    await doc.reference.update(task.toFirestore());
  }

  @override
  Stream<List<TaskModel>> watch({TaskStatus? status, bool newestFirst = true}) {
    final collection = _firestore.collection(collectionPath);

    final query =
        (status != null
                ? collection.where('status', isEqualTo: status.index)
                : collection)
            .orderBy('createdAt', descending: newestFirst);

    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => TaskMapper.fromFirestore(doc)).toList(),
    );
  }

  @override
  Stream<List<TaskModel>> watchAvailable({
    TaskStatus? status,
    bool newestFirst = true,
  }) {
    final collection = _firestore.collection(collectionPath);

    // Build base query
    var query =
        (status != null
                ? collection.where('status', isEqualTo: status.index)
                : collection)
            .where('deleted', isEqualTo: false);

    // Only use orderBy if newestFirst (descending) to use existing index
    // For oldestFirst (ascending), we'll sort in memory to avoid needing another index
    final bool needsClientSideSort = status != null;
    if (newestFirst && !needsClientSideSort) {
      query = query.orderBy('createdAt', descending: true);
    }

    return query.snapshots().map((snapshot) {
      var tasks = snapshot.docs
          .map((doc) => TaskMapper.fromFirestore(doc))
          .toList();

      // If oldestFirst, sort in memory (ascending by createdAt)
      if (needsClientSideSort || !newestFirst) {
        tasks.sort((a, b) {
          final comparsion = a.createdAt.compareTo(b.createdAt);
          return newestFirst ? -comparsion : comparsion;
        });
      }

      return tasks;
    });
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

  @override
  Stream<TaskModel> watchTask(TaskId taskId) {
    return _firestore
        .collection(collectionPath)
        .doc(taskId.value)
        .snapshots()
        .map(TaskMapper.fromFirestore);
  }
}

extension TaskCommentMapper on TaskComment {
  Map<String, dynamic> toFirestore() {
    return {'ownerId': ownerId.value, 'text': text, 'createdAt': createdAt};
  }

  static TaskComment fromFirestore(Map<String, dynamic> data) {
    return TaskComment(
      ownerId: UserId(data['ownerId']),
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
      "dueDate": dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'repeatCycle': repeatCycle.index,
    };
  }

  static TaskModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final assignees = List<String>.from(data['assignees']);
    final comments = List<Map<String, dynamic>>.from(data['comments']);

    // createdAt có thể là null hoặc chưa phải Timestamp (pending serverTimestamp)
    final rawCreatedAt = data['createdAt'];
    DateTime safeCreatedAt;
    if (rawCreatedAt is Timestamp) {
      safeCreatedAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is DateTime) {
      safeCreatedAt = rawCreatedAt;
    } else {
      // Fallback: dùng thời điểm hiện tại nếu field chưa có
      safeCreatedAt = DateTime.now();
    }

    final task = TaskModel(
      id: TaskId.from(doc.id),
      title: data['title'],
      description: data['description'],
      assignees: assignees.map((value) => UserId(value)).toSet(),
      createdAt: safeCreatedAt,

      // WARN: fetching comments can be expensive
      comments: comments
          .map((comment) => TaskCommentMapper.fromFirestore(comment))
          .toList(),

      status: TaskStatus.fromInt(data['status']),
      deleted: data['deleted'],
      repeatCycle: data['repeatCycle'] != null
          ? RepeatCycle.fromInt(data['repeatCycle'])
          : RepeatCycle.none,
    );
    if (data['dueDate'] != null) {
      task.setDueDate((data['dueDate'] as Timestamp).toDate());
    }
    return task;
  }
}
