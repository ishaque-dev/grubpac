import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/core/theme/app_theme.dart';
import 'package:grubpac/core/widgets/app_snackbar.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';
import 'package:grubpac/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:grubpac/features/tasks/presentation/widgets/create_task_sheet.dart';
import 'package:grubpac/features/tasks/presentation/widgets/task_card.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key, required this.project, required this.session});

  final ProjectEntity project;
  final UserSessionEntity session;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: TaskStatus.values.length + 1,
      vsync: this,
    );
    context.read<TaskBloc>().add(
      TasksLoadRequested(projectId: widget.project.id, session: widget.session),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const CutCornerBorder(cut: 20),
      builder: (_) => CreateTaskSheet(
        projectId: widget.project.id,
        session: widget.session,
      ),
    );
  }

  void _updateStatus(String taskId, TaskStatus current) {
    final next =
        TaskStatus.values[(current.index + 1) % TaskStatus.values.length];
    context.read<TaskBloc>().add(
      TaskStatusUpdateRequested(
        taskId: taskId,
        status: next,
        session: widget.session,
      ),
    );
  }

  void _updatePriority(String taskId, TaskPriority current) {
    final next =
        TaskPriority.values[(current.index + 1) % TaskPriority.values.length];
    context.read<TaskBloc>().add(
      TaskPriorityUpdateRequested(
        taskId: taskId,
        priority: next,
        session: widget.session,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.project.name.toUpperCase(),
              style: AppText.display(size: 24.sp),
            ),
            Text(
              AppUiStrings.taskList,
              style: AppText.mono(size: 11.sp, color: AppColors.textMuted),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.lime,
          labelColor: AppColors.lime,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: AppText.mono(size: 10.sp, weight: FontWeight.w700),
          tabs: [
            const Tab(text: AppUiStrings.all),
            ...TaskStatus.values.map((s) => Tab(text: s.name.toUpperCase())),
          ],
        ),
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskFailure) {
            AppSnackbar.showError(context, state.message);
          } else if (state is TaskLoaded && state.message != null) {
            AppSnackbar.showSuccess(context, state.message!);
          }
        },
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading && state is! TaskLoaded) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.lime),
              );
            }

            final allTasks = state is TaskLoaded
                ? state.tasks
                : state is TaskFailure
                ? state.tasks
                : const <TaskEntity>[];

            return TabBarView(
              controller: _tabController,
              children: [
                _TaskList(
                  tasks: allTasks,
                  onStatusTap: _updateStatus,
                  onPriorityTap: _updatePriority,
                  session: widget.session,
                ),
                ...TaskStatus.values.map((status) {
                  final filtered = allTasks
                      .where((t) => t.status == status)
                      .toList();
                  return _TaskList(
                    tasks: filtered,
                    onStatusTap: _updateStatus,
                    onPriorityTap: _updatePriority,
                    session: widget.session,
                  );
                }),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateSheet,
        child: const Icon(Icons.add_task),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.tasks,
    required this.onStatusTap,
    required this.onPriorityTap,
    required this.session,
  });

  final List<TaskEntity> tasks;
  final Function(String, TaskStatus) onStatusTap;
  final Function(String, TaskPriority) onPriorityTap;
  final UserSessionEntity session;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          AppUiStrings.noTasks,
          style: AppText.mono(size: 12.sp, color: AppColors.textFaint),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(24.w),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: TaskCard(
            task: task,
            onStatusTap: () => onStatusTap(task.id!, task.status),
            onPriorityTap: () => onPriorityTap(task.id!, task.priority),
            onDelete: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.card,
                  title: Text(
                    AppUiStrings.deleteTask,
                    style: AppText.display(size: 20.sp),
                  ),
                  content: Text(
                    AppUiStrings.taskDeleteQuestion,
                    style: AppText.body(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        AppUiStrings.cancel,
                        style: AppText.mono(color: AppColors.textMuted),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        AppUiStrings.delete,
                        style: AppText.mono(color: AppColors.danger),
                      ),
                    ),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                context.read<TaskBloc>().add(
                  TaskDeleteRequested(taskId: task.id!, session: session),
                );
              }
            },
          ),
        );
      },
    );
  }
}
