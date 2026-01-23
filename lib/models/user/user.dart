import 'package:hamsa_flutter/models/user/user_id.dart';

class AppUser {
  final UserId id;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final bool isDeleted;
  final DateTime? updatedAt;

  AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.createdAt,
    this.isDeleted = false,
    this.updatedAt,
  });
}
