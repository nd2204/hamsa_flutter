class TaskId {
  final String value;
  TaskId(this.value);

  @override
  bool operator ==(Object other) {
    return other is TaskId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
