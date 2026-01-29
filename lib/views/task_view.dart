import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/viewmodels/task_viewmodel.dart';
import 'package:hamsa_flutter/views/widgets/back_button.dart';
import 'package:provider/provider.dart';

class TaskView extends StatelessWidget {
  final TaskId? taskId;
  const TaskView({super.key, this.taskId});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
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
                                viewModel.isEditing
                                    ? "Chỉnh Sửa Task"
                                    : "Thêm Task Mới",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 24),

                              _TaskViewFieldLabel("Tiêu đề *"),
                              const SizedBox(height: 6),
                              _TaskTextField(
                                controller: viewModel.titleController,
                                hint: "Nhập tiêu đề task",
                              ),

                              const SizedBox(height: 20),

                              _TaskViewFieldLabel("Mô tả *"),
                              const SizedBox(height: 6),
                              _TaskTextField(
                                controller: viewModel.descController,
                                hint: "Nhập mô tả chi tiết",
                                maxLines: 4,
                              ),

                              const SizedBox(height: 24),

                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: _TaskViewDropDownField(
                                        value: viewModel.selectedStatus,
                                        items: TaskStatus.values,
                                        onChanged: viewModel.setStatus,
                                        label: "Trạng thái",
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Expanded(
                                      child: _TaskViewDropDownField(
                                        value: viewModel
                                            .assignedUsers
                                            .firstOrNull
                                            ?.value,
                                        items: viewModel.userList
                                            .map((user) => user.id.value)
                                            .toList(),
                                        itemLabels: viewModel.userList
                                            .map((user) => user.displayName)
                                            .toList(),
                                        onChanged: viewModel.assignUser,
                                        label: "Giao cho",
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              _TaskViewFieldLabel("Hạn hoàn thành"),
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
                                    _TaskViewRepeatCheckbox(viewModel),
                                    if (viewModel.repeatTask)
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: _TaskViewDropDownField(
                                          value: viewModel.repeatCycle,
                                          items: TaskViewModel.repeatCycles,
                                          onChanged: viewModel.setRepeatCycle,
                                          label: "Chu kỳ lặp lại",
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 32),

                              Row(
                                children: [
                                  _TaskViewPrimaryButton(
                                    onPressed: viewModel.isEditing
                                        ? viewModel.saveTask
                                        : () => viewModel.createTask(context),
                                    label: viewModel.isEditing
                                        ? AppStrings.saveTaskButtonTitle
                                        : AppStrings.createTaskButtonTitle,
                                    icon: Icons.save,
                                  ),
                                  const SizedBox(width: 20),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(AppStrings.cancelButton),
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
}

class _TaskViewRepeatCheckbox extends StatelessWidget {
  final TaskViewModel viewModel;
  const _TaskViewRepeatCheckbox(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: viewModel.repeatTask,
          onChanged: viewModel.setRepeatTask,
        ),
        const SizedBox(width: 8),
        const Text("Lặp lại task", style: TextStyle(fontSize: 16)),
      ],
    );
  }
}

class _TaskViewFieldLabel extends StatelessWidget {
  final String text;
  const _TaskViewFieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
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

class _TaskViewPrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData icon;

  const _TaskViewPrimaryButton({
    required this.onPressed,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5B4BFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      // THAY ĐỔI: Label button
      label: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}

class _TaskViewDropDownField<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final List<String>? itemLabels;
  final ValueChanged<T?> onChanged;
  final String label;

  const _TaskViewDropDownField({
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
    this.itemLabels,
  });

  String _getDisplayText() {
    if (value == null) return 'Chọn ${label.toLowerCase()}';

    final index = items.indexOf(value as T);
    if (index >= 0 && itemLabels != null && index < itemLabels!.length) {
      return itemLabels![index];
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TaskViewFieldLabel(label),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: value,
              hint: Text(
                'Chọn ${label.toLowerCase()}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: List.generate(items.length, (index) {
                final item = items[index];
                final displayText =
                    itemLabels != null && index < itemLabels!.length
                    ? itemLabels![index]
                    : item.toString();

                return DropdownMenuItem(value: item, child: Text(displayText));
              }),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
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
