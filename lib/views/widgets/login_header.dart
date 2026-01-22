import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildIcon(),
        const SizedBox(height: 24),
        _buildTitle(),
        const SizedBox(height: 10),
        _buildSubtitle(),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppConstants.primaryColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(Icons.login, color: Colors.white, size: 34),
    );
  }

  Widget _buildTitle() {
    return const Text(
      AppStrings.loginTitle,
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSubtitle() {
    return const Text(
      AppStrings.loginSubtitle,
      style: TextStyle(fontSize: 16, color: Colors.grey),
    );
  }
}
