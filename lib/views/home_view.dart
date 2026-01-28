import 'package:flutter/material.dart';
import 'package:hamsa_flutter/constants/app_constants.dart';
import 'package:hamsa_flutter/constants/routes.dart';
import 'package:hamsa_flutter/models/task/repeat_cycle.dart';
import 'package:hamsa_flutter/models/task/task.dart';
import 'package:hamsa_flutter/models/task/task_status.dart';
import 'package:hamsa_flutter/states/auth_state.dart';
import 'package:hamsa_flutter/utils/injectable.dart';
import 'package:hamsa_flutter/viewmodels/home_viewmodel.dart';
import 'package:hamsa_flutter/views/task_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Map<String, dynamic>> tasks = [];
  String selectedSort = "Mới nhất"; // State cho sort

  final List<String> filteredStatuses = [
    "Tất cả",
    "Chưa bắt đầu",
    "Đang thực hiện",
    "Hoàn thành",
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF6F8FC),
          appBar: _HomeAppBar(viewModel: viewModel, context: context),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressCard(),
                    const SizedBox(height: 24),
                    _buildHeaderRow(),
                    const SizedBox(height: 16),
                    _buildFilterRow(),
                    const SizedBox(height: 24),
                    _buildTasksList(viewModel),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressCard() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return StreamBuilder<List<TaskModel>>(
          stream: viewModel.taskNotifier.watchTasksByStatus(
            status: null, // Lấy tất cả tasks để tính progress
            newestFirst: true,
          ),
          builder: (context, snapshot) {
            // Nếu chưa có dữ liệu, hiển thị loading hoặc 0
            if (!snapshot.hasData) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(AppStrings.taskProgressTitle),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "0 / 0 tasks",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '0%',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5B4BFF),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.0,
                      minHeight: 5,
                      color: Color(0xFF5B4BFF),
                      backgroundColor: Colors.grey,
                    ),
                  ],
                ),
              );
            }

            final allTasks = snapshot.data!;
            final totalTasks = allTasks.length;
            final completedTasks = allTasks
                .where((task) => task.status == TaskStatus.done)
                .length;
            final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
            final percentage = (progress * 100).toInt();

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(AppStrings.taskProgressTitle),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$completedTasks / $totalTasks tasks",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5B4BFF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    color: Color(0xFF5B4BFF),
                    backgroundColor: Colors.grey,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Danh sách Tasks",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5B4BFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          ),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TaskView()),
            );

            if (result != null) {
              // Kiểm tra xem có phải edit hay create
              if (result['isEdit'] == true) {
                // Trường hợp EDIT: Cập nhật task cũ
                setState(() {
                  tasks[result['index']] = result['task'];
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã cập nhật task'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } else {
                // Trường hợp CREATE: Thêm task mới
                setState(() {
                  tasks.add(result['task']);
                });
              }
            }
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Thêm Task",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          height: 60,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Row(
            children: [
              const Icon(Icons.filter_alt_outlined),
              const SizedBox(width: 8),
              const Text("Trạng thái:"),
              const SizedBox(width: 8),
              // Dropdown for status filter
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: viewModel.getSelectedStatusString(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    borderRadius: BorderRadius.circular(12),
                    dropdownColor: Colors.grey.shade200,
                    items: const [
                      DropdownMenuItem(value: "Tất cả", child: Text("Tất cả")),
                      DropdownMenuItem(
                        value: "Chưa bắt đầu",
                        child: Text("Chưa bắt đầu"),
                      ),
                      DropdownMenuItem(
                        value: "Đang thực hiện",
                        child: Text("Đang thực hiện"),
                      ),
                      DropdownMenuItem(
                        value: "Hoàn thành",
                        child: Text("Hoàn thành"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        viewModel.setSelectedStatusFromString(value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.sort),
              const SizedBox(width: 8),
              const Text("Sắp xếp: "),
              const SizedBox(width: 8),

              // Dropdown for sort
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedSort,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    borderRadius: BorderRadius.circular(12),
                    dropdownColor: Colors.grey.shade200,
                    itemHeight: 50,
                    items: const [
                      DropdownMenuItem(
                        value: "Mới nhất",
                        child: Text("Mới nhất"),
                      ),
                      DropdownMenuItem(
                        value: "Cũ nhất",
                        child: Text("Cũ nhất"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedSort = value!;
                      });
                      // Cập nhật sort order trong viewModel
                      viewModel.setSortOrder(value == "Mới nhất");
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTasksList(HomeViewModel viewModel) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Consumer<HomeViewModel>(
          builder: (context, vm, child) {
            return StreamBuilder<List<TaskModel>>(
              key: ValueKey(
                '${vm.newestFirst}-${vm.selectedStatus}',
              ), // Key để tránh tạo stream mới mỗi lần rebuild
              stream: vm.taskNotifier.watchTasksByStatus(
                newestFirst: vm.newestFirst,
                status: vm.selectedStatus,
              ),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (asyncSnapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Lỗi: ${asyncSnapshot.error}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (!asyncSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = asyncSnapshot.data!;

                // Display no task
                if (data.isEmpty) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            AppStrings.noTask,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Nếu có tasks, hiển thị danh sách
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return _buildTaskCard(
                      data[index],
                      index,
                      context,
                      viewModel,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskCard(
    TaskModel task,
    int index,
    BuildContext context,
    HomeViewModel viewModel,
  ) {
    final title = task.title;
    final description = task.description;
    final status = task.status;
    final statusDisplayName = status.displayName;

    // Xác định màu và icon theo status
    Color iconColor;
    Color borderColor;
    IconData iconData;

    switch (status) {
      case TaskStatus.done:
        iconColor = const Color(0xFF16A34A); // Xanh lá cây
        borderColor = const Color(0xFF16A34A);
        iconData = Icons.check_circle; // Icon đầy màu xanh
        break;
      case TaskStatus.inProgress:
        iconColor = const Color.fromARGB(255, 82, 137, 255);
        borderColor = const Color.fromARGB(255, 82, 137, 255);
        iconData =
            Icons.play_circle_filled; // Hoặc Icons.hourglass_empty, Icons.timer
        break;
      case TaskStatus.todo:
        iconColor = Colors.grey.shade400; // Xám
        borderColor = Colors.grey.shade300;
        iconData = Icons.check_circle_outline; // Icon outline
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: status == TaskStatus.done || status == TaskStatus.inProgress
              ? 2
              : 1,
        ),
      ),
      child: Row(
        children: [
          // Icon bên trái - có thể click để toggle status
          Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
              return InkWell(
                onTap: () {
                  viewModel.toggleTaskStatus(task.id);
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(iconData, color: iconColor, size: 24),
                ),
              );
            },
          ),
          const SizedBox(width: 16),

          // Phần nội dung chính
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),

                // Description
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Footer: Status badge, assignee, date
                Row(
                  children: [
                    // Status badge
                    _buildStatusBadge(statusDisplayName),
                    const SizedBox(width: 12),

                    // Assignee
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),

                    const SizedBox(width: 12),

                    // Thêm frequency info
                    if (task.repeatCycle != RepeatCycle.none)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.repeat_on_outlined,
                              size: 16,
                              color: Colors.grey, //
                            ),
                            const SizedBox(width: 6),
                            Text(
                              task.repeatCycle.displayName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey, // 🆕 Text màu trắng
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(width: 12),

                    // Calendar icon
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.formattedDueDate,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2 buttons bên phải: Edit, Delete
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit button
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                color: const Color(0xFF5B4BFF),
                iconSize: 20,
                onPressed: viewModel.navigateToEditTaskCallback(
                  context,
                  task.id,
                ),
              ),

              // Delete button
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
                iconSize: 20,
                onPressed: () async {
                  final viewModel = Provider.of<HomeViewModel>(
                    context,
                    listen: false,
                  );
                  await viewModel.deleteTask(task.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(AppStrings.taskDeleted),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // THÊM: Widget hiển thị status badge
  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'Done':
      case 'Hoàn thành':
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF16A34A);
        break;
      case 'In Progress':
      case 'Đang thực hiện':
        bgColor = const Color(0xFFDEEBFF);
        textColor = const Color(0xFF2563EB);
        break;
      default:
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF6B7280);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HomeAppBar extends AppBar {
  final HomeViewModel viewModel;
  final BuildContext context;

  _HomeAppBar({required this.viewModel, required this.context})
    : super(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: const [
            Icon(Icons.check_box_outlined, color: Color(0xFF5B4BFF)),
            SizedBox(width: 8),
            Text(AppStrings.appTitle, style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: getIt<AuthStateNotifier>(),
            builder: (context, value, child) {
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: viewModel.navigateToProfileCallback(context),
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
                        value.currentUser?.displayName ?? "N/a",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 24),
          TextButton.icon(
            onPressed: () async {
              final AuthStateNotifier notifier = getIt<AuthStateNotifier>();
              final confirmed = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(AppStrings.signOutConfirmTitle),
                  content: const Text(AppStrings.signOutConfirmMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(AppStrings.cancelButton),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(AppStrings.signOutButton),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await notifier.signOut();
                if (context.mounted) {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(AppRoute.login.name);
                }
              }
            },
            icon: const Icon(Icons.logout, color: Colors.grey),
            label: const Text(
              AppStrings.logoutButtonTitle,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
        ],
      );
}
