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

  Stream<List<TaskModel>> watchTasksByStatus({
    TaskStatus? status,
    bool newestFirst = true,
  }) {
    return taskRepository.watchAvailable(
      status: status,
      newestFirst: newestFirst,
    );
  }
}

class HomeViewModel extends ChangeNotifier {
  AppUser? _user;
  bool _newestFirst = true; // State cho sắp xếp
  TaskStatus? _selectedStatus;

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

  bool get newestFirst => _newestFirst;
  TaskStatus? get selectedStatus => _selectedStatus;

  void setSortOrder(bool newestFirst) {
    _newestFirst = newestFirst;
    notifyListeners();
  }

  void setSelectedStatus(TaskStatus? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  // Helper method để map string UI sang TaskStatus
  TaskStatus? _mapStringToTaskStatus(String statusString) {
    switch (statusString) {
      case "Tất cả":
        return null;
      case "Chưa bắt đầu":
        return TaskStatus.todo;
      case "Đang thực hiện":
        return TaskStatus.inProgress;
      case "Hoàn thành":
        return TaskStatus.done;
      default:
        return null;
    }
  }

  void setSelectedStatusFromString(String statusString) {
    setSelectedStatus(_mapStringToTaskStatus(statusString));
    notifyListeners();
  }

   // Helper method để map TaskStatus sang string UI
  String getSelectedStatusString() {
    if (_selectedStatus == null) return "Tất cả";
    switch (_selectedStatus!) {
      case TaskStatus.todo:
        return "Chưa bắt đầu";
      case TaskStatus.inProgress:
        return "Đang thực hiện";
      case TaskStatus.done:
        return "Hoàn thành";
    }
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

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
