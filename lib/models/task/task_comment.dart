import 'package:hamsa_flutter/models/user/user_id.dart';

class TaskComment {
  final UserId ownerId;
  final String text;
  final DateTime createdAt;

  TaskComment({
    required this.ownerId,
    required this.text,
    required this.createdAt,
  });
}
