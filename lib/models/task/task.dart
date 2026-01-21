import 'package:hamsa_flutter/models/task/task_comment.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/user/user_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/utils/errors.dart';

class TaskModel {
  final TaskId id;
  final String title;
  final String description;

  bool _deleted;
  bool get deleted => _deleted;

  final DateTime? _createdAt;
  DateTime get createdAt {
    if (_createdAt != null) return _createdAt;
    throw StateError(message: 'createdAt should not be null');
  }

  TaskStatus _status;
  TaskStatus get status => _status;

  DateTime? _dueDate;
  DateTime? get dueDate => _dueDate;

  final List<TaskComment> _comments;
  List<TaskComment> get comments => _comments;

  final Set<UserId> _assignees;
  Iterable<UserId> get assignees => _assignees;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    bool? deleted,
    TaskStatus? status,
    Set<UserId>? assignees,
    List<TaskComment>? comments,
    DateTime? createdAt,
  }) : _assignees = assignees ?? {},
       _status = status ?? TaskStatus.todo,
       _comments = comments ?? [],
       _createdAt = createdAt,
       _deleted = deleted ?? false;

  void markDeleted() {
    _deleted = true;
  }

  void setDueDate(DateTime dueDate) {
    if (dueDate.isBefore(createdAt)) {
      throw ValueError(
        value: dueDate,
        reason: "Due date must be after the time of task creation",
      );
    }
    _dueDate = dueDate;
  }

  void markDone() {
    if (_status == TaskStatus.todo) {
      throw StateError(message: 'Can not mark todo task as done');
    }
    _status = TaskStatus.done;
  }

  void markInProgress() {
    _status = TaskStatus.inProgress;
  }

  void markTodo() {
    _status = TaskStatus.todo;
  }

  void assignUser(UserId uid) {
    if (_assignees.add(uid)) return;
    throw StateError(message: "User already assigned to this task");
  }

  void unassignUser(UserId uid) {
    if (_assignees.remove(uid)) return;
    throw StateError(message: "User is not assigned to this task");
  }

  void addComment(TaskComment comment) {
    _comments.add(comment);
  }

  @override
  String toString() =>
      "TaskModel("
      "id=$id,"
      "title=$title,"
      "description=$description,"
      "deleted=$_deleted,"
      "createdAt=$_createdAt,"
      "status=$status,"
      "dueDate=$dueDate,"
      "comments=${comments.map((c) => c.toString())},"
      "assignees=${assignees.map((u) => u.value)}"
      ")";
}
