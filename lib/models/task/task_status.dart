enum TaskStatus {
  todo('Todo'),
  inProgress('In Progress'),
  done('Done');

  const TaskStatus(this.displayName);

  factory TaskStatus.fromString(String str) {
    return TaskStatus.values.firstWhere((e) => e.name == str);
  }

  factory TaskStatus.fromInt(int idx) {
    return TaskStatus.values.firstWhere((e) => e.index == idx);
  }

  final String displayName;
}
