enum TaskStatus { todo, inProgress, done }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final String assignedTo;
  final DateTime createdAt;
  final DateTime? dueDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.assignedTo,
    required this.createdAt,
    this.dueDate,
  });
}
