import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/utils/injectable.dart';
import 'package:hamsa_flutter/viewmodels/edit_task_viewmodel.dart';
import 'package:hamsa_flutter/views/widgets/back_button.dart';
import 'package:provider/provider.dart';

typedef EditTaskModelSelector<T> = Selector<EditTaskViewModel, T>;

class EditTaskView extends StatelessWidget {
  final TaskId taskId;
  const EditTaskView({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt.get<EditTaskViewModel>(param1: taskId),
      child: _EditTaskBody(),
    );
  }
}

class _EditTaskBody extends StatelessWidget {
  const _EditTaskBody();

  @override
  Widget build(BuildContext context) {
    return Selector<EditTaskViewModel, bool>(
      selector: (_, vm) => vm.isLoaded,
      builder: (_, loaded, _) {
        if (!loaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return const _EditTaskForm();
      },
    );
  }
}

class _EditTaskForm extends StatelessWidget {
  const _EditTaskForm();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<EditTaskViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    AppBackButton(),
                    _TaskCard(vm: vm),
                  ],
                ),
              ),
            ),
          ),
          const _EditTaskErrorListener(),
        ],
      ),
    );
  }
}

class _EditTaskErrorListener extends StatelessWidget {
  const _EditTaskErrorListener();

  @override
  Widget build(BuildContext context) {
    return Selector<EditTaskViewModel, String?>(
      selector: (_, vm) => vm.error,
      builder: (_, error, _) {
        if (error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: Colors.red),
            );

            context.read<EditTaskViewModel>().clearError();
          });
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  final EditTaskViewModel vm;
  const _TaskCard({required this.vm});

  @override
  Widget build(BuildContext context) {
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
              "Chỉnh Sửa Task",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            _TaskViewFieldLabel("Tiêu đề *"),
            const SizedBox(height: 6),
            _TaskTextField(
              controller: vm.titleController,
              hint: "Nhập tiêu đề task",
            ),

            const SizedBox(height: 20),

            _TaskViewFieldLabel("Mô tả *"),
            const SizedBox(height: 6),
            _TaskTextField(
              controller: vm.descController,
              hint: "Nhập mô tả chi tiết",
              maxLines: 4,
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Selector<EditTaskViewModel, TaskStatus>(
                  builder: (_, value, _) {
                    return Expanded(
                      child: _TaskViewDropDownField(
                        value: value,
                        items: TaskStatus.values,
                        onChanged: vm.setStatus,
                        label: "Trạng thái",
                      ),
                    );
                  },
                  selector: (_, vm) => vm.selectedStatus,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _TaskViewDropDownField(
                    value: vm.assignedUsers.firstOrNull?.value ?? "what",
                    items: <String>["what"], // TODO: add user
                    onChanged: vm.assignUser,
                    label: "Giao cho",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _TaskViewFieldLabel("Hạn hoàn thành"),
            const SizedBox(height: 6),
            TextField(
              controller: vm.displayDateController,
              readOnly: true,
              decoration: _TaskInputDecoration("dd/mm/yyyy"),
              onTap: () => vm.setDueDate(context),
            ),

            const SizedBox(height: 24),

            _TaskRepeatSection(vm: vm),

            const SizedBox(height: 32),

            Row(
              children: [
                _TaskViewPrimaryButton(
                  onPressed: () async {
                    final ok = await vm.saveTask();
                    if (ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Saved task"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.of(context).maybePop();
                    }
                  },
                  label: AppStrings.saveTaskButtonTitle,
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
    );
  }
}

class _TaskRepeatSection extends StatelessWidget {
  const _TaskRepeatSection({required this.vm});
  final EditTaskViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: EditTaskModelSelector<bool>(
        selector: (_, vm) => vm.repeatTask,
        builder: (context, repeat, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TaskViewRepeatCheckbox(),
              if (repeat)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Selector<EditTaskViewModel, String>(
                    builder: (_, selectedRepeatCycle, child) {
                      return _TaskViewDropDownField(
                        value: selectedRepeatCycle,
                        items: vm.repeatCycles,
                        onChanged: vm.setRepeatCycle,
                        label: "Chu kỳ lặp lại",
                      );
                    },
                    selector: (_, vm) => vm.selectedRepeatCycle.displayName,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TaskViewRepeatCheckbox extends StatelessWidget {
  const _TaskViewRepeatCheckbox();

  @override
  Widget build(BuildContext context) {
    return Selector<EditTaskViewModel, bool>(
      selector: (_, vm) => vm.repeatTask,
      builder: (_, repeat, _) {
        final vm = context.read<EditTaskViewModel>();
        return Row(
          children: [
            Checkbox(value: repeat, onChanged: vm.setRepeatTask),
            const SizedBox(width: 8),
            const Text("Lặp lại task", style: TextStyle(fontSize: 16)),
          ],
        );
      },
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
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String label;

  const _TaskViewDropDownField({
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
  });

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
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item.toString()),
                );
              }).toList(),
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
