import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hamsa_flutter/models/user/user.dart';
import 'package:hamsa_flutter/services/auth_service.dart';
import 'package:hamsa_flutter/utils/validators.dart';
import 'package:hamsa_flutter/utils/auth_error_mapper.dart';

class SignUpViewModel extends ChangeNotifier {
  final IAuthService _authService;
  StreamSubscription<AppUser?>? _authSubscription;

  SignUpViewModel(this._authService) {
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
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
  bool get isDisplayNameValid =>
      Validators.isValidDisplayName(displayNameController.text);
  bool get isEmailValid => Validators.isValidEmail(emailController.text);
  bool get isPasswordValid =>
      Validators.isValidPassword(passwordController.text);
  bool get isConfirmPasswordValid =>
      passwordController.text == confirmPasswordController.text &&
      confirmPasswordController.text.isNotEmpty;

  bool get canSignUp =>
      isDisplayNameValid &&
      isEmailValid &&
      isPasswordValid &&
      isConfirmPasswordValid &&
      !_isLoading;

  // Error messages for each field
  String? get displayNameError =>
      Validators.displayNameError(displayNameController.text);
  String? get emailError => Validators.emailError(emailController.text);
  String? get passwordError =>
      Validators.passwordError(passwordController.text);
  String? get confirmPasswordError => Validators.confirmPasswordError(
    passwordController.text,
    confirmPasswordController.text,
  );

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void onFieldChanged() {
    // Called when any field changes to trigger validation
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

  Future<bool> signUp() async {
    if (!canSignUp) {
      _setError('Vui lòng nhập đầy đủ thông tin');
      return false;
    }

    // Kiểm tra mật khẩu khớp
    if (passwordController.text != confirmPasswordController.text) {
      _setError('Mật khẩu xác nhận không khớp');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      final user = await _authService.signUpWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
        displayNameController.text.trim(),
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

  @override
  void dispose() {
    _authSubscription?.cancel();
    displayNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
