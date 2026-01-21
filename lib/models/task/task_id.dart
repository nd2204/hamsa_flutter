import 'package:hamsa_flutter/utils/uuid.dart';

class TaskId {
  final String value;
  TaskId._(this.value);

  factory TaskId.newId() => TaskId._(uuid.v4());
  factory TaskId.from(String v) => TaskId._(v);

  @override
  bool operator ==(Object other) {
    return other is TaskId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
