import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/routes.dart';
import 'package:provider/provider.dart';
import 'package:hamsa_flutter/viewmodels/login_viewmodel.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';
import 'package:hamsa_flutter/views/widgets/login_header.dart';
import 'package:hamsa_flutter/views/widgets/login_email_field.dart';
import 'package:hamsa_flutter/views/widgets/login_password_field.dart';
import 'package:hamsa_flutter/views/widgets/login_error_message.dart';
import 'package:hamsa_flutter/views/widgets/login_submit_button.dart';
import 'package:hamsa_flutter/views/widgets/login_form_card.dart';
import 'package:hamsa_flutter/views/widgets/login_signup_link.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AppConstants.backgroundColor,
          body: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppConstants.maxFormWidth,
                ),
                child: LoginFormCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const LoginHeader(),
                      const SizedBox(height: 28),
                      LoginEmailField(viewModel: viewModel),
                      const SizedBox(height: 20),
                      LoginPasswordField(viewModel: viewModel),
                      const SizedBox(height: 16),
                      LoginErrorMessage(viewModel: viewModel),
                      const SizedBox(height: 30),
                      LoginSubmitButton(
                        viewModel: viewModel,
                        onPressed: viewModel.signIn,
                      ),
                      const SizedBox(height: 24),
                      const LoginSignUpLink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
