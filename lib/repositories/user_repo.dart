import 'package:hamsa_flutter/models/user/user.dart';
import 'package:hamsa_flutter/models/user/user_id.dart';

abstract class IUserRepository {
  Future<void> create(AppUser user);
  Future<AppUser?> get(UserId id);
  Future<void> update(AppUser user);
  Future<void> delete(UserId id);
  Future<void> markDeleted(UserId id);

  // System admin level access
  Future<List<AppUser>> listAll();
  Stream<List<AppUser>> watchAll();
}
