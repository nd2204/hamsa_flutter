import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';
import 'package:hamsa_flutter/utils/validators.dart';
import 'package:hamsa_flutter/viewmodels/login_viewmodel.dart';

class LoginPasswordField extends StatelessWidget {
  final LoginViewModel viewModel;

  const LoginPasswordField({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.passwordLabel,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: viewModel.passwordController,
          obscureText: true,
          onChanged: (_) => viewModel.clearError(),
          decoration: InputDecoration(
            hintText: "••••••••",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.defaultBorderRadius,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            errorText: Validators.passwordError(
              viewModel.passwordController.text,
            ),
          ),
        ),
      ],
    );
  }
}
