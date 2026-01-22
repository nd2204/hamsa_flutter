import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';
import 'package:hamsa_flutter/constants/routes.dart';

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
            Navigator.pushNamed(context, AppRoute.signup.name);
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
