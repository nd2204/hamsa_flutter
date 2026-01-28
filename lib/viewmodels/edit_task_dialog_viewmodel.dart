import 'package:flutter/material.dart';
import 'package:hamsa_flutter/models/task/repeat_cycle.dart';
import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/models/user/user_id.dart';
import 'package:hamsa_flutter/repositories/task_repo.dart';
import 'package:hamsa_flutter/services/task_service.dart';
import 'package:hamsa_flutter/utils/errors.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditTaskDialogViewModel extends ChangeNotifier {
  List<String> repeatCycles = RepeatCycle.values
      .map((v) => v.displayName)
      .toList();

  EditTaskDialogViewModel(
    this._taskService,
    this._taskRepo,
    @factoryParam this._taskId,
  ) {
    _load();
  }

  final ITaskService _taskService;
  final ITaskRepository _taskRepo;
  final TaskId _taskId;
  TaskModel? _loadedTask;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController displayDateController = TextEditingController();

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  TaskStatus _selectedStatus = TaskStatus.todo;
  TaskStatus get selectedStatus => _selectedStatus;

  RepeatCycle _selectedRepeatCycle = RepeatCycle.none;
  RepeatCycle get selectedRepeatCycle => _selectedRepeatCycle;

  bool _repeatTask = false;
  bool get repeatTask => _repeatTask;

  DateTime? _selectedDate;
  DateTime? get taskDueDate => _selectedDate;

  List<UserId> _assignedUsers = [];
  List<UserId> get assignedUsers => _assignedUsers;

  String? _error;
  String? get error => _error;

  Future<void> _load() async {
    try {
      final task = await _taskRepo.findById(_taskId);
      if (task == null) {
        throw NotFoundError(message: "Task does not exists");
      }

      titleController.text = task.title;
      descController.text = task.description;

      _selectedStatus = task.status;
      _selectedRepeatCycle = task.repeatCycle;
      _repeatTask = task.repeatCycle != RepeatCycle.none;

      if (task.dueDate != null) {
        _selectedDate = task.dueDate;
        _setDisplayDate(task.dueDate!);
      }

      _isLoaded = true;
      _loadedTask = task;
      notifyListeners();
    } catch (e) {
      _emitError(e);
      _isLoaded = true;
      notifyListeners();
    }
  }

  void _emitError(Object e) {
    if (e is StateError) {
      _error = e.message;
    } else {
      _error = e.toString();
    }
    notifyListeners();
  }

  void clearError() {
    _error = null;
  }

  void setStatus(TaskStatus? value) {
    if (value == null || value == _selectedStatus) return;
    _selectedStatus = value;
    notifyListeners();
  }

  void setRepeatTask(bool? value) {
    if (value == null || value == _repeatTask) return;
    _repeatTask = value;
    notifyListeners();
  }

  void setRepeatCycle(String? value) {
    if (value == null) return;
    final cycle = RepeatCycle.fromString(value);
    if (cycle == _selectedRepeatCycle) return;

    _selectedRepeatCycle = cycle;
    notifyListeners();
  }

  void assignUser(String? value) {
    if (value == null) return;
    _assignedUsers = [UserId(value)];
    notifyListeners();
  }

  void setDueDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 20),
    );

    if (picked != null) {
      _selectedDate = picked;
      _setDisplayDate(picked);
      notifyListeners();
    }
  }

  void _setDisplayDate(DateTime date) {
    displayDateController.text = "${date.day}/${date.month}/${date.year}";
  }

  Future<bool> saveTask() async {
    try {
      if (_loadedTask == null) {
        throw StateError(message: 'loaded task should not be null');
      }
      _loadedTask!.title = titleController.text;
      _loadedTask!.description = descController.text;
      _loadedTask!
        ..setStatus(selectedStatus)
        ..setRepeatCycle(selectedRepeatCycle)
        ..setDueDate(taskDueDate);
      await _taskService.saveTask(_loadedTask!);
      return true;
    } catch (e) {
      _emitError(e);
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    displayDateController.dispose();
    super.dispose();
  }
}
