import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';
import 'package:hamsa_flutter/utils/validators.dart';
import 'package:hamsa_flutter/viewmodels/login_viewmodel.dart';

class LoginEmailField extends StatelessWidget {
  final LoginViewModel viewModel;

  const LoginEmailField({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.emailLabel,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: viewModel.emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => viewModel.clearError(),
          decoration: InputDecoration(
            hintText: 'your.email@example.com',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.defaultBorderRadius,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            errorText: Validators.emailError(viewModel.emailController.text),
          ),
        ),
      ],
    );
  }
}
