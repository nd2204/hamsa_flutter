import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hamsa_flutter/models/user/user.dart';
import 'package:hamsa_flutter/services/auth_service.dart';
import 'package:hamsa_flutter/repositories/user_repo.dart';
import 'package:hamsa_flutter/utils/errors.dart';
import 'package:hamsa_flutter/utils/validators.dart';

class ProfileViewModel extends ChangeNotifier {
  final IAuthService _authService;
  final IUserRepository _userRepository;
  StreamSubscription<AppUser?>? _authSubscription;

  ProfileViewModel(this._authService, this._userRepository) {
    _initializeAuthListener();
  }

  // Form controllers
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // State
  AppUser? _currentUser;
  AppUser? _userData;
  bool _isEditing = false;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  AppUser? get currentUser => _currentUser;
  AppUser? get userData => _userData;
  bool get isEditing => _isEditing;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // Validation
  bool get isDisplayNameValid =>
      Validators.isValidDisplayName(displayNameController.text);
  bool get isEmailValid => Validators.isValidEmail(emailController.text);
  bool get canSave => isDisplayNameValid && isEmailValid && !_isSaving;

  String? get displayNameError =>
      Validators.displayNameError(displayNameController.text);
  String? get emailError => Validators.emailError(emailController.text);

  // Initialize auth listener
  void _initializeAuthListener() async {
    _authSubscription = _authService.authStateChanges.listen((user) async {
      _currentUser = user;
      if (user != null) {
        await loadUserData();
      } else {
        _userData = null;
        notifyListeners();
      }
    });
  }

  // Load user data from repository
  Future<void> loadUserData() async {
    if (_currentUser == null) return;

    _setLoading(true);
    _setError(null);

    try {
      // Get user data from repository
      final user = await _userRepository.get(_currentUser!.id);
      _userData = user;
      if (user != null) {
        displayNameController.text = user.displayName;
        emailController.text = user.email;
      }
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setError('Không thể tải thông tin người dùng: ${e.toString()}');
    }
  }

  // Start editing
  void startEditing() {
    if (_userData == null) return;

    _isEditing = true;
    displayNameController.text = _userData!.displayName;
    emailController.text = _userData!.email;
    _clearMessages();
    notifyListeners();
  }

  // Cancel editing
  void cancelEditing() {
    _isEditing = false;
    displayNameController.clear();
    emailController.clear();
    _clearMessages();
    notifyListeners();
  }

  // Save changes
  Future<bool> saveChanges() async {
    if (_userData == null || !canSave) {
      _setError('Vui lòng nhập đầy đủ thông tin hợp lệ');
      return false;
    }

    _setSaving(true);
    _clearMessages();

    try {
      final updatedUser = AppUser(
        id: _userData!.id,
        email: emailController.text.trim(),
        displayName: displayNameController.text.trim(),
        createdAt: _userData!.createdAt,
      );

      await _userRepository.update(updatedUser);
      _userData = updatedUser;
      _isEditing = false;
      _setSaving(false);
      _setSuccess('Đã lưu thay đổi thành công');
      return true;
    } on NotFoundError catch (e) {
      _setSaving(false);
      _setError('Không thể lưu thay đổi: ${e.message}');
      return false;
    } catch (e) {
      _setSaving(false);
      _setError('Không thể lưu thay đổi: ${e.toString()}');
      return false;
    } finally {
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _currentUser = null;
      _userData = null;
      _isEditing = false;
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setError('Không thể đăng xuất: ${e.toString()}');
    }
  }

  void onFieldChanged() {
    _clearMessages();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccess(String? success) {
    _successMessage = success;
    _errorMessage = null;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    displayNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
