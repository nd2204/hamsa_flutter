import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';
import 'package:hamsa_flutter/models/task/task_id.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/utils/injectable.dart';
import 'package:hamsa_flutter/viewmodels/edit_task_dialog_viewmodel.dart';
import 'package:provider/provider.dart';

typedef _Selector<T> = Selector<EditTaskDialogViewModel, T>;

class EditTaskDialog extends StatelessWidget {
  final TaskId taskId;
  const EditTaskDialog({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt.get<EditTaskDialogViewModel>(param1: taskId),
      child: _EditTaskDialogBody(),
    );
  }
}

class _EditTaskDialogBody extends StatelessWidget {
  const _EditTaskDialogBody();

  @override
  Widget build(BuildContext context) {
    return _Selector(
      selector: (_, vm) => vm.isLoaded,
      builder: (_, loaded, _) {
        if (!loaded) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              width: 800,
              height: 600,
              child: Center(child: const CircularProgressIndicator()),
            ),
          );
        }

        return const _EditTaskDialogContent();
      },
    );
  }
}

class _EditTaskDialogContent extends StatelessWidget {
  const _EditTaskDialogContent();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: _TaskCard(),
          ),

          // Error listener stays
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
    return _Selector<String?>(
      selector: (_, vm) => vm.error,
      builder: (_, error, _) {
        if (error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: Colors.red),
            );

            context.read<EditTaskDialogViewModel>().clearError();
          });
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<EditTaskDialogViewModel>();
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
                _Selector<TaskStatus>(
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
            const _TaskRepeatSection(),
            const SizedBox(height: 32),
            const _FormActionsSection(),
          ],
        ),
      ),
    );
  }
}

class _FormActionsSection extends StatelessWidget {
  const _FormActionsSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .end,
      children: [
        _FormCancelButton(
          onPressed: () => Navigator.pop(context),
          label: AppStrings.cancelButton,
        ),
        const SizedBox(width: 12),
        _FormSaveButton(
          onPressed: () async {
            final ok = await context.read<EditTaskDialogViewModel>().saveTask();
            if (context.mounted) Navigator.of(context).pop(ok);
          },
          label: AppStrings.saveTaskButtonTitle,
          icon: Icons.save,
        ),
      ],
    );
  }
}

class _TaskRepeatSection extends StatelessWidget {
  const _TaskRepeatSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _Selector<bool>(
        selector: (_, vm) => vm.repeatTask,
        builder: (context, repeat, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TaskViewRepeatCheckbox(),
              if (repeat)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _Selector<String>(
                    builder: (context, selectedRepeatCycle, child) {
                      final vm = context.read<EditTaskDialogViewModel>();
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
    return _Selector<bool>(
      selector: (_, vm) => vm.repeatTask,
      builder: (_, repeat, _) {
        final vm = context.read<EditTaskDialogViewModel>();
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

class _FormCancelButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const _FormCancelButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      ),
      onPressed: onPressed,
      // THAY ĐỔI: Label button
      child: Text(label, style: const TextStyle(color: Colors.black)),
    );
  }
}

class _FormSaveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData icon;

  const _FormSaveButton({
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
