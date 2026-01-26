import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';

abstract class ITaskRepository {
  Future<void> create(TaskModel task);
  Future<List<TaskModel>> listAll();
  Future<List<TaskModel>> listAllAvailable();
  Future<TaskModel?> findById(TaskId taskId);
  Future<void> save(TaskModel task);
  Future<void> delete(TaskId id);
  Future<void> markDeleted(TaskId id, [bool value = true]);
  Stream<List<TaskModel>> watch({TaskStatus? status});
  Stream<List<TaskModel>> watchAvailable({TaskStatus? status});
  Future<List<TaskModel>> listByStatus(TaskStatus status);
}
