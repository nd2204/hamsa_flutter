import 'dart:async';
import 'package:hamsa_flutter/repositories/user_repo.dart';
import 'package:hamsa_flutter/services/user_service.dart';

class UserServiceImpl implements IUserService {
  final IUserRepository _repository;

  final _controller = StreamController<UserList>.broadcast();
  StreamSubscription<UserList>? _subscription;
  UserList? _cache;
  bool _started = false;

  UserServiceImpl(this._repository);

  @override
  Stream<UserList> watchAll() async* {
    _ensureStarted();

    // Replay latest value immediately
    if (_cache != null) {
      yield _cache!;
    }

    // Then forward live updates
    yield* _controller.stream;
  }

  void _ensureStarted() {
    if (_started) return;
    _started = true;

    _subscription = _repository.watchAll().listen((users) {
      _cache = users;
      _controller.add(users);
    }, onError: _controller.addError);
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
