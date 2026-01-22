import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hamsa_flutter/models/user/user.dart';
import 'package:hamsa_flutter/services/auth_service.dart';
import 'package:hamsa_flutter/utils/validators.dart';
import 'package:hamsa_flutter/utils/auth_error_mapper.dart';

class LoginViewModel extends ChangeNotifier {
  final IAuthService _authService;
  StreamSubscription<AppUser?>? _authSubscription;

  LoginViewModel(this._authService) {
    _initializeAuthListener();
  }

  // Initialize auth listener
  void _initializeAuthListener() {
    _authSubscription = _authService.authStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

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

  Future<bool> signIn() async {
    if (!canSignIn) {
      _setError('Vui lòng nhập đầy đủ thông tin');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      final user = await _authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      _currentUser = user;
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(AuthErrorMapper.map(e));
      return false;
    }
  }

  Future<void> signOut() async {
    _setLoading(true);

    try {
      await _authService.signOut();
      _currentUser = null;
      _setError(null);
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setError(AuthErrorMapper.map(e));
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
