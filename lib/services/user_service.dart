import 'package:hamsa_flutter/models/user/user.dart';

typedef UserList = List<AppUser>;

abstract class IUserService {
  Stream<UserList> watchAll();
}
