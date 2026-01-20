enum TaskStatus {
  todo('Todo'),
  inProgress('In Progress'),
  done('Done');

  const TaskStatus(this.displayName);

  final String displayName;
}
