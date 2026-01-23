import 'package:flutter/material.dart';
import 'package:hamsa_flutter/models/task/task.dart';

class AddTaskView extends StatefulWidget {
  final TaskModel? taskToEdit;
  final int? taskIndex; // Index của task trong list

  const AddTaskView({super.key, this.taskToEdit, this.taskIndex});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String selectedStatus = "Chưa bắt đầu";
  String selectedUser = "Chọn người thực hiện";
  bool repeatTask = false;
  String repeatCycle = "Hàng ngày";

  final List<String> statusList = [
    "Chưa bắt đầu",
    "Đang thực hiện",
    "Hoàn thành",
  ];

  final List<String> userList = [
    "Chọn người thực hiện",
    "Nguyễn Văn A",
    "Trần Thị B",
    "Do Sy Chien",
  ];

  // THÊM: Kiểm tra có phải edit mode không
  bool get isEditMode => widget.taskToEdit != null;

  @override
  void initState() {
    super.initState();
    // THÊM: Nếu edit mode, điền dữ liệu cũ vào form
    if (isEditMode) {
      titleController.text = widget.taskToEdit!.title;
      descController.text = widget.taskToEdit!.description;
      dateController.text = widget.taskToEdit!.dueDate.toString();
      selectedStatus = widget.taskToEdit!.status.displayName;
      selectedUser = widget.taskToEdit!.assignees.first.value;
      repeatTask = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackButton(),
                Expanded(child: _buildFormAddTask()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.arrow_back, size: 20),
            SizedBox(width: 6),
            Text("Quay lại", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildFormAddTask() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // THAY ĐỔI: Title khác nhau cho edit/create
            Text(
              isEditMode ? "Chỉnh Sửa Task" : "Thêm Task Mới",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            _buildLabel("Tiêu đề *"),
            const SizedBox(height: 6),
            _buildTextField(
              controller: titleController,
              hint: "Nhập tiêu đề task",
            ),

            const SizedBox(height: 20),

            _buildLabel("Mô tả *"),
            const SizedBox(height: 6),
            _buildTextField(
              controller: descController,
              hint: "Nhập mô tả chi tiết",
              maxLines: 4,
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Trạng thái"),
                      const SizedBox(height: 6),
                      _buildDropdown(
                        value: selectedStatus,
                        items: statusList,
                        onChanged: (value) {
                          setState(() => selectedStatus = value!);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Giao cho"),
                      const SizedBox(height: 6),
                      _buildDropdown(
                        value: selectedUser,
                        items: userList,
                        onChanged: (value) {
                          setState(() => selectedUser = value!);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildLabel("Hạn hoàn thành"),
            const SizedBox(height: 6),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: _inputDecoration("dd/mm/yyyy"),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  setState(() {
                    dateController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: repeatTask,
                        onChanged: (value) {
                          setState(() {
                            repeatTask = value!;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Lặp lại task",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  if (repeatTask) ...[
                    const SizedBox(height: 12),
                    _buildLabel("Chu kỳ lặp lại"),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      value: repeatCycle,
                      items: [
                        "Hàng ngày",
                        "Hàng tuần",
                        "Hàng tháng",
                        "Hàng năm",
                      ],
                      onChanged: (value) {
                        setState(() {
                          repeatCycle = value!;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B4BFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () {
                    // Validate
                    if (titleController.text.trim().isEmpty ||
                        descController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vui lòng nhập đầy đủ thông tin'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Tạo task object
                    final taskData = {
                      'title': titleController.text.trim(),
                      'description': descController.text.trim(),
                      'status': selectedStatus,
                      'assignedTo': selectedUser,
                      'dueDate': dateController.text.isEmpty
                          ? 'Chưa có'
                          : dateController.text,
                      'repeat': repeatTask,
                    };

                    // THÊM: Return với thông tin edit
                    Navigator.pop(context, {
                      'task': taskData,
                      'isEdit': isEditMode,
                      'index': widget.taskIndex,
                    });
                  },
                  icon: const Icon(Icons.save, color: Colors.white),
                  // THAY ĐỔI: Label button
                  label: Text(
                    isEditMode ? "Lưu Thay Đổi" : "Tạo Task",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Hủy"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    if (text.endsWith('*')) {
      final mainText = text.substring(0, text.length - 1);
      return Text.rich(
        TextSpan(
          style: const TextStyle(fontWeight: FontWeight.w500),
          children: [
            TextSpan(
              text: mainText,
              style: const TextStyle(color: Colors.black),
            ),
            const TextSpan(
              text: '*',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: _inputDecoration(hint),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF5B4BFF)),
      ),
    );
  }
}
