import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _displayName = "Sỹ Chiến";
  String _displayEmail = "dschien1@gmail.com";

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;

      _nameController.text = _displayName;
      _emailController.text = _displayEmail;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;

      _nameController.clear();
      _emailController.clear();
    });
  }

  void _saveChanges() {
    setState(() {
      _displayName = _nameController.text;
      _displayEmail = _emailController.text;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu thay đổi thành công'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      // start app bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: const [
            Icon(Icons.check_box_outlined, color: Color(0xFF5B4BFF)),
            SizedBox(width: 8),
            Text('Task Manager', style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              // Đã ở ProfileView rồi, không cần navigate
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: const [
                  Icon(Icons.person, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('Do Sy Chien', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout, color: Colors.grey),
            label: const Text("Logout", style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      // end app bar
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  headline và botton edit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Thông tin cá nhân",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    _isEditing
                        ? Row(
                            children: [
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: _cancelEditing,
                                icon: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                label: const Text(
                                  "Hủy",
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
                                onPressed: _saveChanges,
                                icon: const Icon(
                                  Icons.save,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Lưu thay đổi",
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
                            onPressed: _startEditing,
                            icon: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Chỉnh sửa",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ],
                ),

                const SizedBox(height: 16),

                // profile card
                _buildProfileCard(),

                const SizedBox(height: 24),

                // stats card
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
                      const Text(
                        "Thống kê",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          Expanded(
                            child: _StatCard(
                              title: "ID Người dùng",
                              value: "1769060147992",
                              color: Color(0xFFEFF6FF),
                              titleColor: Color(0xFF2563EB),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _StatCard(
                              title: "Trạng thái",
                              value: "Hoạt động",
                              color: Color(0xFFF0FDF4),
                              titleColor: Color(0xFF16A34A),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _StatCard(
                              title: "Loại tài khoản",
                              value: "Người dùng",
                              color: Color(0xFFF5F3FF),
                              titleColor: Color(0xFF7C3AED),
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
  }

  Widget _buildProfileCard() {
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

              // avatar
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

          // info section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isEditing
                    ? _buildEditableField(
                        title: "Họ và tên",
                        icon: Icons.person_outline,
                        controller: _nameController,
                      )
                    : _buildInfoRow(
                        title: "Họ và tên",
                        icon: Icons.person_outline,
                        value: _displayName,
                      ),

                const SizedBox(height: 16),

                _isEditing
                    ? _buildEditableField(
                        title: "Email",
                        icon: Icons.email_outlined,
                        controller: _emailController,
                      )
                    : _buildInfoRow(
                        title: "Email",
                        icon: Icons.email_outlined,
                        value: _displayEmail,
                      ),

                const SizedBox(height: 16),

                _buildInfoRow(
                  title: "Ngày tham gia",
                  icon: Icons.calendar_today_outlined,
                  value: "22 tháng 1, 2026",
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
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  // show editable text field
  Widget _buildEditableField({
    required String title,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey, size: 20),
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
}

// stats card
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
