import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/repositories/task_repo.dart';

class TaskService implements ITaskRepository{
  @override
  Future<void> create(TaskModel task) {
    // TODO: implement createTask
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> get(String id) {
    // TODO: implement getTask
    throw UnimplementedError();
  }

  @override
  Future<void> update(TaskModel task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
  @override
  Stream<List<TaskModel>> watch(String id) {
    // TODO: implement watchTasks
    throw UnimplementedError();
  }
  
  @override
  Future<List<TaskModel>> list(String id) {
    // TODO: implement fetchTasks
    throw UnimplementedError();
  }
  
  @override
  Future<List<TaskModel>> getByStatus(TaskStatus status) {
    // TODO: implement getByStatus
    throw UnimplementedError();
  }
}
