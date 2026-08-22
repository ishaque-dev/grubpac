import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/core/theme/app_theme.dart';
import 'package:grubpac/core/widgets/app_snackbar.dart';
import 'package:grubpac/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';
import 'package:grubpac/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:grubpac/features/projects/presentation/widgets/create_project_sheet.dart';
import 'package:grubpac/features/projects/presentation/widgets/edit_project_sheet.dart';
import 'package:grubpac/features/projects/presentation/widgets/project_card.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key, required this.session});

  final UserSessionEntity session;

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectsBloc>().add(ProjectsLoadRequested(widget.session));
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const CutCornerBorder(cut: 20),
      builder: (_) => CreateProjectSheet(session: widget.session),
    );
  }

  void _showEditSheet(ProjectEntity project) {
    if (widget.session.role != UserRole.orgAdmin) {
      _showUnauthorizedMessage();
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const CutCornerBorder(cut: 20),
      builder: (_) =>
          EditProjectSheet(project: project, session: widget.session),
    );
  }

  Future<void> _confirmDelete(ProjectEntity project) async {
    if (widget.session.role != UserRole.orgAdmin) {
      _showUnauthorizedMessage();
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppUiStrings.deleteProjectQuestion),
        content: Text(
          AppUiStrings.projectDeleteWarning.replaceFirst(
            '{name}',
            project.name,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppUiStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(AppUiStrings.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<ProjectsBloc>().add(
        ProjectDeleteRequested(projectId: project.id, session: widget.session),
      );
    }
  }

  void _showUnauthorizedMessage() {
    AppSnackbar.showError(context, AppUiStrings.projectAdminOnly);
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppUiStrings.logoutQuestion),
        content: const Text(AppUiStrings.logoutWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppUiStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(AppUiStrings.signOut),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<AuthBloc>().add(AuthLogoutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppUiStrings.projects, style: AppText.display(size: 28.sp)),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: AppUiStrings.signOut,
            onPressed: _confirmLogout,
            icon: const Icon(Icons.logout),
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: BlocListener<ProjectsBloc, ProjectsState>(
        listener: (context, state) {
          if (state is ProjectsFailure) {
            AppSnackbar.showError(context, state.message);
          } else if (state is ProjectsLoaded && state.message != null) {
            AppSnackbar.showSuccess(context, state.message!);
          }
        },
        child: BlocBuilder<ProjectsBloc, ProjectsState>(
          builder: (context, state) {
            if (state is ProjectsLoading && state is! ProjectsLoaded) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.lime),
              );
            }

            final projects = state is ProjectsLoaded
                ? state.projects
                : state is ProjectsFailure
                ? state.projects
                : [];

            if (projects.isEmpty && state is! ProjectsLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 64.sp,
                      color: AppColors.textFaint,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      AppUiStrings.noProjects,
                      style: AppText.mono(
                        size: 14.sp,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.lime,
              onRefresh: () async {
                context.read<ProjectsBloc>().add(
                  ProjectsLoadRequested(widget.session),
                );
              },
              child: GridView.builder(
                padding: EdgeInsets.all(24.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisExtent: 160.h,
                  mainAxisSpacing: 16.h,
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return ProjectCard(
                    project: project,
                    onEdit: () => _showEditSheet(project),
                    onDelete: () => _confirmDelete(project),
                    onTap: () {
                      context.push(
                        '/projects/${project.id}/tasks',
                        extra: project,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateSheet,
        icon: const Icon(Icons.add),
        label: Text(
          AppUiStrings.newProject,
          style: AppText.mono(size: 12.sp, weight: FontWeight.w700),
        ),
      ),
    );
  }
}
