import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';

abstract class ITaskService {
  Future<void> createTask({
    required String title,
    TaskStatus? status,
    String? description,
  });

  Future<void> markDeleteTask(TaskId id);

  Future<void> deleteTask(TaskId id);
}
