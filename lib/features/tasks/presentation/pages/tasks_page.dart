import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/di/di.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/core/theme/app_theme.dart';
import 'package:grubpac/core/widgets/app_snackbar.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';
import 'package:grubpac/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:grubpac/features/tasks/presentation/widgets/create_task_sheet.dart';
import 'package:grubpac/features/tasks/presentation/widgets/task_card.dart';
import 'package:grubpac/features/team/domain/entities/member_entity.dart';
import 'package:grubpac/features/team/domain/use_cases/get_members_use_case.dart';

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
  late Future<List<MemberEntity>> _membersFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: TaskStatus.values.length + 1,
      vsync: this,
    );
    _membersFuture = _loadMembers();
    context.read<TaskBloc>().add(
      TasksLoadRequested(projectId: widget.project.id, session: widget.session),
    );
  }

  Future<List<MemberEntity>> _loadMembers() async {
    final result = await serviceLocator<GetMembersUseCase>()(
      parameters: widget.session,
    );
    return result.fold((_) => const <MemberEntity>[], (members) => members);
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
      builder: (_) => FutureBuilder<List<MemberEntity>>(
        future: _membersFuture,
        builder: (context, snapshot) => CreateTaskSheet(
          projectId: widget.project.id,
          session: widget.session,
          members: snapshot.data ?? const <MemberEntity>[],
        ),
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
        child: FutureBuilder<List<MemberEntity>>(
          future: _membersFuture,
          builder: (context, membersSnapshot) =>
              BlocBuilder<TaskBloc, TaskState>(
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
                        members: membersSnapshot.data ?? const <MemberEntity>[],
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
                          members:
                              membersSnapshot.data ?? const <MemberEntity>[],
                        );
                      }),
                    ],
                  );
                },
              ),
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
    required this.members,
  });

  final List<TaskEntity> tasks;
  final Function(String, TaskStatus) onStatusTap;
  final Function(String, TaskPriority) onPriorityTap;
  final UserSessionEntity session;
  final List<MemberEntity> members;

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
            assignee: task.assigneeId == null
                ? null
                : members.cast<MemberEntity?>().firstWhere(
                    (member) => member?.id == task.assigneeId,
                    orElse: () => null,
                  ),
            onEdit: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: AppColors.bg,
              shape: const CutCornerBorder(cut: 20),
              builder: (_) => CreateTaskSheet(
                projectId: task.projectId,
                session: session,
                members: members,
                initialTask: task,
              ),
            ),
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
