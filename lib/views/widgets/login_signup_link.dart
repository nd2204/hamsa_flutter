import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';

class LoginSignUpLink extends StatelessWidget {
  const LoginSignUpLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(AppStrings.noAccount),
        GestureDetector(
          onTap: () {
            // TODO: Navigate to sign up view
            print('Sign up link clicked');
          },
          child: const Text(
            AppStrings.signUpNow,
            style: TextStyle(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
