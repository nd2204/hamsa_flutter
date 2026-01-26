import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/repositories/task_repo.dart';
import 'package:hamsa_flutter/services/task_service.dart';

class TaskServiceImpl extends ITaskService {
  final ITaskRepository _repo;

  TaskServiceImpl(this._repo);

  @override
  Future<void> createTask({
    required String title,
    TaskStatus? status,
    String? description,
  }) async {
    // TODO: add validation

    await _repo.create(
      TaskModel(
        id: TaskId.newId(),
        title: title,
        description: description ?? '',
      ),
    );
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
