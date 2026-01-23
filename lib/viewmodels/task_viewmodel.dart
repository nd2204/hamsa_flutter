import 'package:flutter/material.dart';
import 'package:hamsa_flutter/models/user/user_id.dart';
import 'package:hamsa_flutter/services/task_service.dart';

class TaskViewModel extends ChangeNotifier {
  final ITaskService taskService;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  static const List<String> repeatCycles = [
    "Hàng ngày",
    "Hàng tuần",
    "Hàng tháng",
    "Hàng năm",
  ];

  String selectedStatus = "Chưa bắt đầu";
  List<UserId> assignedUsers = [];
  bool repeatTask = false;
  String repeatCycle = repeatCycles.first;

  TaskViewModel(this.taskService);

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void setStatus(String? value) {
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

  void setRepeatCycle(String? value) {
    repeatCycle = value!;
    notifyListeners();
  }

  void createTask(BuildContext context) async {
    // Validate
    if (titleController.text.trim().isEmpty ||
        descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Tạo task object
    final taskData = {
      'title': titleController.text.trim(),
      'description': descController.text.trim(),
      'status': selectedStatus,
      'assignedTo': assignedUsers.firstOrNull ?? [],
      'dueDate': dateController.text.isEmpty ? 'Chưa có' : dateController.text,
      'repeat': repeatTask,
    };

    // THÊM: Return với thông tin edit
    Navigator.pop(context);

    await taskService.createTask(
      title: titleController.text,
      description: descController.text,
      // TODO: add due date
    );
  }
}
