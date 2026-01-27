import 'package:flutter/material.dart';
import 'package:hamsa_flutter/models/task/repeat_cycle.dart';
import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/models/user/user_id.dart';
import 'package:hamsa_flutter/repositories/task_repo.dart';
import 'package:hamsa_flutter/services/task_service.dart';

class TaskViewModel extends ChangeNotifier {
  static const List<String> repeatCycles = [
    "Không lặp lại",
    "Hàng ngày",
    "Hàng tuần",
    "Hàng tháng",
    "Hàng năm",
  ];

  RepeatCycle selectedRepeatCycle = RepeatCycle.none;

  void setRepeatCycle(String? value) {
    if (value == null) return;
    selectedRepeatCycle = RepeatCycle.fromString(value);
    notifyListeners();
  }

  final ITaskService taskService;
  final ITaskRepository taskRepo;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  TaskModel? _loadedTask;

  TaskStatus selectedStatus = TaskStatus.todo;
  List<UserId> assignedUsers = [];
  bool repeatTask = false;
  String repeatCycle = repeatCycles.first;

  TaskViewModel(this.taskService, this.taskRepo);

  void loadTask(TaskId taskId) {
    // TODO: handle error
    taskRepo.findById(taskId).then((task) {
      _loadedTask = task;
      notifyListeners();
    });
  }

  bool get isEditing => _loadedTask != null;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void setStatus(TaskStatus? value) {
    selectedStatus = value!;
    notifyListeners();
  }

  void assignUser(String? value) {
    assignedUsers.add(UserId(value!));
    notifyListeners();
  }

  void setDueDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      dateController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      notifyListeners();
    }
  }

  void setRepeatTask(bool? value) {
    repeatTask = value!;
    notifyListeners();
  }

  void saveTask() async {
    if (_loadedTask == null) throw StateError('task should not be null');
    await taskService.saveTask(_loadedTask!);
  }

  void createTask(BuildContext context) async {
    final titleSanitized = titleController.text.trim();
    final descSanitized = descController.text.trim();

    // Validate
    if (titleSanitized.isEmpty || descSanitized.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    DateTime? parseDueDate;
    if (dateController.text.isNotEmpty) {
      try {
        final parts = dateController.text.split('/');
        if (parts.length == 3) {
          parseDueDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (e) {
        // Handle parsing error if needed
      }
    }

    if (parseDueDate != null && parseDueDate.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể chọn ngày đã qua làm hạn task!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // THÊM: Return với thông tin edit
    Navigator.pop(context);

    await taskService.createTask(
      title: titleController.text,
      description: descController.text,
      status: selectedStatus,
      dueDate: parseDueDate,
      repeatCycle: selectedRepeatCycle,
    );
  }
}
