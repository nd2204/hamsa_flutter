import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';
import 'package:hamsa_flutter/constants/routes.dart';
import 'package:hamsa_flutter/models/user/user.dart';
import 'package:hamsa_flutter/services/auth_service.dart';

class HomeViewModel extends ChangeNotifier {
  AppUser? _user;
  final IAuthService _authService;

  HomeViewModel(IAuthService authService) : _authService = authService;

  String get userDisplayName => _user?.displayName ?? AppStrings.notAvailable;

  VoidCallback? navigateToProfileCallback(BuildContext context) {
    return () => Navigator.pushNamed(context, AppRoute.userProfile.name);
  }

  VoidCallback? navigateToAddTaskCallback(BuildContext context) {
    return () => Navigator.pushNamed(context, AppRoute.addTask.name);
  }
}
