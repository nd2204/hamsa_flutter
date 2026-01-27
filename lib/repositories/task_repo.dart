import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';

abstract class ITaskRepository {
  Future<void> create(TaskModel task);
  Future<List<TaskModel>> listAll({bool newestFirst = true});
  Future<List<TaskModel>> listAllAvailable({bool newestFirst = true});
  Future<TaskModel?> findById(TaskId taskId);
  Future<void> save(TaskModel task);
  Future<void> delete(TaskId id);
  Future<void> markDeleted(TaskId id, [bool value = true]);
  Stream<List<TaskModel>> watch({TaskStatus? status, bool newestFirst = true});
  Stream<List<TaskModel>> watchAvailable({TaskStatus? status, bool newestFirst = true});
  Future<List<TaskModel>> listByStatus(TaskStatus status, {bool newestFirst = true});
}
