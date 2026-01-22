import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hamsa_flutter/viewmodels/profile_viewmodel.dart';
import 'package:hamsa_flutter/constants/routes.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        // Show loading indicator while loading user data
        if (viewModel.isLoading && viewModel.userData == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFF6F8FC),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Show error if no user data
        if (viewModel.userData == null && !viewModel.isLoading) {
          return Scaffold(
            backgroundColor: const Color(0xFFF6F8FC),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage ?? AppStrings.userNotFound,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF6F8FC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            title: Row(
              children: const [
                Icon(Icons.check_box_outlined, color: Color(0xFF5B4BFF)),
                SizedBox(width: 8),
                Text(
                  AppStrings.appTitle,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            actions: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  // Đã ở ProfileView rồi, không cần navigate
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        viewModel.userData?.displayName ??
                            AppStrings.defaultUserName,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              TextButton.icon(
                onPressed: () => _handleSignOut(context, viewModel),
                icon: const Icon(Icons.logout, color: Colors.grey),
                label: const Text(
                  AppStrings.logoutButton,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Headline và button edit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.profileTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        viewModel.isEditing
                            ? Row(
                                children: [
                                  OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: viewModel.isSaving
                                        ? null
                                        : () => viewModel.cancelEditing(),
                                    icon: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    label: const Text(
                                      AppStrings.cancelButton,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4F46E5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed:
                                        viewModel.canSave && !viewModel.isSaving
                                        ? () => _handleSaveChanges(
                                            context,
                                            viewModel,
                                          )
                                        : null,
                                    icon: viewModel.isSaving
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.save,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                    label: const Text(
                                      AppStrings.saveChangesButton,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )
                            : ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4F46E5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () => viewModel.startEditing(),
                                icon: const Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  AppStrings.editButton,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Error/Success messages
                    if (viewModel.errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                viewModel.errorMessage!,
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (viewModel.successMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.green.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                viewModel.successMessage!,
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Profile card
                    _buildProfileCard(viewModel),

                    const SizedBox(height: 24),

                    // Stats card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 10),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.statsTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: AppStrings.userIdLabel,
                                  value:
                                      viewModel.userData?.id.value ??
                                      AppStrings.notAvailable,
                                  color: const Color(0xFFEFF6FF),
                                  titleColor: const Color(0xFF2563EB),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _StatCard(
                                  title: AppStrings.statusLabel,
                                  value: AppStrings.activeStatus,
                                  color: const Color(0xFFF0FDF4),
                                  titleColor: const Color(0xFF16A34A),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _StatCard(
                                  title: AppStrings.accountTypeLabel,
                                  value: AppStrings.userAccountType,
                                  color: const Color(0xFFF5F3FF),
                                  titleColor: const Color(0xFF7C3AED),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(ProfileViewModel viewModel) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 140,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
              // Avatar
              Positioned(
                bottom: -50,
                left: 24,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E7FF),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 6),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          // Info section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                viewModel.isEditing
                    ? _buildEditableField(
                        title: AppStrings.fullNameLabel,
                        icon: Icons.person_outline,
                        controller: viewModel.displayNameController,
                        errorText: viewModel.displayNameError,
                        onChanged: () => viewModel.onFieldChanged(),
                      )
                    : _buildInfoRow(
                        title: AppStrings.fullNameLabel,
                        icon: Icons.person_outline,
                        value: viewModel.userData?.displayName ?? '',
                      ),
                const SizedBox(height: 16),
                viewModel.isEditing
                    ? _buildEditableField(
                        title: AppStrings.emailLabel,
                        icon: Icons.email_outlined,
                        controller: viewModel.emailController,
                        errorText: viewModel.emailError,
                        onChanged: () => viewModel.onFieldChanged(),
                      )
                    : _buildInfoRow(
                        title: AppStrings.emailLabel,
                        icon: Icons.email_outlined,
                        value: viewModel.userData?.email ?? '',
                      ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  title: AppStrings.joinDateLabel,
                  icon: Icons.calendar_today_outlined,
                  value: viewModel.userData?.createdAt != null
                      ? _formatDate(viewModel.userData!.createdAt)
                      : AppStrings.notAvailable,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(icon, color: Colors.grey, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditableField({
    required String title,
    required IconData icon,
    required TextEditingController controller,
    String? errorText,
    required VoidCallback onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: (_) => onChanged(),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey, size: 20),
            errorText: errorText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSaveChanges(
    BuildContext context,
    ProfileViewModel viewModel,
  ) async {
    final success = await viewModel.saveChanges();
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.saveSuccessMessage),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'tháng 1',
      'tháng 2',
      'tháng 3',
      'tháng 4',
      'tháng 5',
      'tháng 6',
      'tháng 7',
      'tháng 8',
      'tháng 9',
      'tháng 10',
      'tháng 11',
      'tháng 12',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  Future<void> _handleSignOut(
    BuildContext context,
    ProfileViewModel viewModel,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.signOutConfirmTitle),
        content: const Text(AppStrings.signOutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(AppStrings.signOutButton),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await viewModel.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoute.login.name);
      }
    }
  }
}

// Stats card
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final Color titleColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
