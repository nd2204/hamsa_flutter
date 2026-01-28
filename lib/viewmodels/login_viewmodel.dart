import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hamsa_flutter/models/user/user.dart';
import 'package:hamsa_flutter/services/auth_service.dart';
import 'package:hamsa_flutter/states/auth_state.dart';
import 'package:hamsa_flutter/utils/injectable.dart';
import 'package:hamsa_flutter/utils/validators.dart';
import 'package:hamsa_flutter/utils/auth_error_mapper.dart';

class LoginViewModel extends ChangeNotifier {
  final IAuthService _authService;
  final AuthStateNotifier _authStateNotifier = getIt.get<AuthStateNotifier>();

  StreamSubscription<AppUser?>? _authSubscription;

  LoginViewModel(this._authService);

  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // State
  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Validation
  bool get isEmailValid => Validators.isValidEmail(emailController.text);
  bool get isPasswordValid =>
      Validators.isValidPassword(passwordController.text);
  bool get canSignIn => isEmailValid && isPasswordValid && !_isLoading;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> signIn() async {
    if (!canSignIn) {
      _setError('Vui lòng nhập đầy đủ thông tin');
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
      // Auth state notifier listen to auth state
      await _authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );
    } catch (e) {
      _setError(AuthErrorMapper.map(e));
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
