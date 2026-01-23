import 'package:flutter/material.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/viewmodels/task_viewmodel.dart';
import 'package:hamsa_flutter/views/widgets/back_button.dart';
import 'package:provider/provider.dart';

class TaskView extends StatelessWidget {
  final TaskId? taskId;
  const TaskView({super.key, this.taskId});

  bool get isEditMode => taskId != null;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, viewModel, child) {
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
                    AppBackButton(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 10),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // THAY ĐỔI: Title khác nhau cho edit/create
                              Text(
                                isEditMode ? "Chỉnh Sửa Task" : "Thêm Task Mới",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 24),

                              _buildLabel("Tiêu đề *"),
                              const SizedBox(height: 6),
                              _TaskTextField(
                                controller: viewModel.titleController,
                                hint: "Nhập tiêu đề task",
                              ),

                              const SizedBox(height: 20),

                              _buildLabel("Mô tả *"),
                              const SizedBox(height: 6),
                              _TaskTextField(
                                controller: viewModel.descController,
                                hint: "Nhập mô tả chi tiết",
                                maxLines: 4,
                              ),

                              const SizedBox(height: 24),

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildLabel("Trạng thái"),
                                        const SizedBox(height: 6),
                                        _TaskViewDropDown(
                                          value: viewModel.selectedStatus,
                                          items: [],
                                          onChanged: viewModel.setStatus,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildLabel("Giao cho"),
                                        const SizedBox(height: 6),
                                        _TaskViewDropDown(
                                          value: viewModel
                                              .assignedUsers
                                              .first
                                              .value,
                                          items: [], // TODO: add user
                                          onChanged: viewModel.assignUser,
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
                                controller: viewModel.dateController,
                                readOnly: true,
                                decoration: _TaskInputDecoration("dd/mm/yyyy"),
                                onTap: () => viewModel.setDueDate(context),
                              ),

                              const SizedBox(height: 24),

                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: viewModel.repeatTask,
                                          onChanged: viewModel.setRepeatTask,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "Lặp lại task",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    if (viewModel.repeatTask) ...[
                                      const SizedBox(height: 12),
                                      _buildLabel("Chu kỳ lặp lại"),
                                      const SizedBox(height: 6),
                                      _TaskViewDropDown(
                                        value: viewModel.repeatCycle,
                                        items: TaskViewModel.repeatCycles,
                                        onChanged: viewModel.setRepeatCycle,
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
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.save,
                                      color: Colors.white,
                                    ),
                                    // THAY ĐỔI: Label button
                                    label: Text(
                                      isEditMode ? "Lưu Thay Đổi" : "Tạo Task",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
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
}

class _TaskViewDropDown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _TaskViewDropDown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
}

class _TaskInputDecoration extends InputDecoration {
  _TaskInputDecoration(String hint)
    : super(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
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

class _TaskTextField extends TextField {
  _TaskTextField({super.controller, super.maxLines = 1, required String hint})
    : super(decoration: _TaskInputDecoration(hint));
}
