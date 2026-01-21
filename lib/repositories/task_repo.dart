import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';

abstract class ITaskRepository {
  Future<void> create(TaskModel task);
  Future<List<TaskModel>> list(String id);
  Future<TaskModel?> findById(TaskId taskId);
  Future<void> update(TaskModel task);
  Future<void> delete(String id);
  Stream<List<TaskModel>> watch(String id);
  Future<List<TaskModel>> getByStatus(TaskStatus status);
}
