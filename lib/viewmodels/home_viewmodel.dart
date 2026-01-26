import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';
import 'package:hamsa_flutter/constants/routes.dart';
import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/models/user/user.dart';
import 'package:hamsa_flutter/repositories/task_repo.dart';
import 'package:hamsa_flutter/services/auth_service.dart';

class TaskListValueNotifier extends ValueNotifier<List<TaskModel>> {
  final ITaskRepository taskRepository;

  TaskListValueNotifier(super.value, this.taskRepository);

  Stream<List<TaskModel>> watchTasksByStatus({TaskStatus? status}) {
    return taskRepository.watch(status: status);
  }
}

class HomeViewModel extends ChangeNotifier {
  AppUser? _user;

  final IAuthService _authService;
  final TaskListValueNotifier taskNotifier;

  HomeViewModel(IAuthService authService, ITaskRepository taskRepo)
    : _authService = authService,
      taskNotifier = TaskListValueNotifier([], taskRepo) {
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  String get userDisplayName => _user?.displayName ?? AppStrings.notAvailable;

  VoidCallback? navigateToProfileCallback(BuildContext context) {
    return () => Navigator.pushNamed(context, AppRoute.userProfile.name);
  }

  VoidCallback? navigateToAddTaskCallback(BuildContext context) {
    return () => Navigator.pushNamed(context, AppRoute.task.name);
  }

  Future<void> deleteTask(TaskId taskId) async {
    await taskNotifier.taskRepository.markDeleted(taskId);
  }
}
