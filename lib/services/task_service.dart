import 'package:hamsa_flutter/models/task/repeat_cycle.dart';
import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/models/user/user_id.dart';

abstract class ITaskService {
  Future<void> saveTask(TaskModel task);

  Future<void> createTask({
    required String title,
    TaskStatus? status,
    String? description,
    DateTime? dueDate,
    RepeatCycle? repeatCycle,
    Set<UserId>? assignees,
  });

  Future<void> markDeleteTask(TaskId id);

  Future<void> deleteTask(TaskId id);
}
