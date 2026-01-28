import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';
import 'package:hamsa_flutter/viewmodels/login_viewmodel.dart';

class LoginSubmitButton extends StatelessWidget {
  final LoginViewModel viewModel;
  final VoidCallback onPressed;

  const LoginSubmitButton({
    super.key,
    required this.viewModel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
        ),
        onPressed: viewModel.isLoading || !viewModel.canSignIn
            ? null
            : onPressed,
        child: viewModel.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                AppStrings.loginButton,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }
}
