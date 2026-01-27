import 'package:hamsa_flutter/models/task/repeat_cycle.dart';
import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/repositories/task_repo.dart';
import 'package:hamsa_flutter/services/task_service.dart';
import 'package:hamsa_flutter/utils/injectable.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ITaskService)
class TaskServiceImpl extends ITaskService {
  final ITaskRepository _repo;

  TaskServiceImpl() : _repo = getIt<ITaskRepository>();

  @override
  Future<void> createTask({
    required String title,
    TaskStatus? status,
    String? description,
    DateTime? dueDate,
    RepeatCycle? repeatCycle,
  }) async {
    // TODO: add validation
    final task = TaskModel(
      id: TaskId.newId(),
      title: title,
      description: description ?? '',
      status: status,
      createdAt: DateTime.now(),
      repeatCycle: repeatCycle ?? RepeatCycle.none,
    );

    if (dueDate != null) {
      task.setDueDate(dueDate);
    }

    await _repo.create(task);
  }

  @override
  Future<void> deleteTask(TaskId id) async {
    await _repo.delete(id);
  }

  @override
  Future<void> markDeleteTask(TaskId id) async {
    await _repo.markDeleted(id);
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    // todo add validation
    await _repo.save(task);
  }
}
