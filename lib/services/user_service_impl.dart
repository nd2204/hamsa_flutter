import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:hamsa_flutter/repositories/user_repo.dart';
import 'package:hamsa_flutter/services/user_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IUserService)
class UserServiceImpl implements IUserService, Disposable {
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

  @override
  FutureOr<dynamic> onDispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
