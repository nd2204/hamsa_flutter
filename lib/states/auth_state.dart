import 'package:flutter/material.dart';
import 'package:hamsa_flutter/models/user/user.dart';
import 'package:hamsa_flutter/services/auth_service.dart';
import 'package:hamsa_flutter/utils/auth_error_mapper.dart';
import 'package:hamsa_flutter/utils/injectable.dart';
import 'package:injectable/injectable.dart';

enum AuthStatus { loading, error, authenticated, unauthenticated }

class AuthState {
  final AuthStatus authStatus;
  final String? message;
  final dynamic errorObj;
  final AppUser? currentUser;

  bool get isLoading => authStatus == .loading;

  const AuthState({
    required this.authStatus,
    this.message,
    this.currentUser,
    this.errorObj,
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    String? message,
    AppUser? currentUser,
    dynamic errorObj,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      message: message ?? this.message,
      currentUser: currentUser ?? this.currentUser,
      errorObj: currentUser,
    );
  }
}

@LazySingleton()
class AuthStateNotifier extends ValueNotifier<AuthState> {
  final IAuthService _authService;
  AuthStateNotifier()
    : _authService = getIt.get<IAuthService>(),
      super(const AuthState(authStatus: AuthStatus.loading)) {
    _authService.authStateChanges.listen((user) {
      _setLoading();
      if (user == null) {
        _setUnauthenticated();
      } else {
        _setAuthenticated(user);
      }
    }, onError: _setError);
  }

  Future<void> signOut() async {
    _setLoading();
    try {
      await _authService.signOut();
      _setUnauthenticated();
    } catch (e) {
      _setError(e);
    }
  }

  void _setLoading() {
    value = value.copyWith(authStatus: AuthStatus.loading);
    notifyListeners();
  }

  void _setUnauthenticated() {
    value = value.copyWith(
      authStatus: AuthStatus.unauthenticated,
      currentUser: null,
      message: null,
    );
    notifyListeners();
  }

  void _setError(dynamic e) {
    value = value.copyWith(
      authStatus: .error,
      message: AuthErrorMapper.map(e),
      errorObj: e,
    );
    notifyListeners();
  }

  void _setAuthenticated(AppUser user) {
    value = AuthState(authStatus: .authenticated, currentUser: user);
    notifyListeners();
  }
}
