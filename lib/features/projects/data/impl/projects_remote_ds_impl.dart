import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/utils/mock_data.dart';
import 'package:grubpac/core/utils/parsing_santizer.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/projects/data/data_sources/i_projects_remote_ds.dart';
import 'package:grubpac/features/projects/data/models/create_project_request_model.dart';
import 'package:grubpac/features/projects/data/models/project_model.dart';
import 'package:grubpac/features/projects/data/models/update_project_request_model.dart';

class ProjectsRemoteDsImpl implements IProjectsRemoteDs {
  static const Duration _mockDelay = Duration(milliseconds: 300);
  List<ProjectModel>? _projects;

  @override
  Future<List<ProjectModel>> getProjects({
    required UserSessionModel session,
  }) async {
    await _loadProjects();
    return _projects!
        .where((project) => project.organizationId == session.organizationId)
        .toList(growable: false);
  }

  @override
  Future<ProjectModel> getProjectById({
    required String projectId,
    required UserSessionModel session,
  }) async {
    final projects = await getProjects(session: session);
    return projects.firstWhere((project) => project.id == projectId);
  }

  @override
  Future<ProjectModel> createProject({
    required CreateProjectRequestModel request,
    required UserSessionModel session,
  }) async {
    await _loadProjects();
    final project = ProjectModel(
      id: 'proj_${DateTime.now().millisecondsSinceEpoch}',
      organizationId: session.organizationId,
      name: request.name,
      description: request.description,
      taskCount: 0,
      status: 'active',
      createdAt: DateTime.now(),
    );
    _projects!.add(project);
    return project;
  }

  @override
  Future<ProjectModel> updateProject({
    required UpdateProjectRequestModel request,
    required UserSessionModel session,
  }) async {
    await _loadProjects();
    final index = _projects!.indexWhere(
      (project) =>
          project.id == request.projectId &&
          project.organizationId == session.organizationId,
    );
    if (index < 0) {
      throw StateError('Project not found');
    }

    final updatedProject = _projects![index].copyWith(
      name: request.name,
      description: request.description,
      status: request.status,
    );
    _projects![index] = updatedProject;
    return updatedProject;
  }

  @override
  Future<void> deleteProject({
    required String projectId,
    required UserSessionModel session,
  }) async {
    await _loadProjects();
    final originalLength = _projects!.length;
    _projects!.removeWhere(
      (project) =>
          project.id == projectId &&
          project.organizationId == session.organizationId,
    );
    if (_projects!.length == originalLength) {
      throw StateError('Project not found');
    }
  }

  Future<void> _loadProjects() async {
    if (_projects != null) {
      return;
    }
    await Future.delayed(_mockDelay);
    final data = await MockApiResponse.load();
    final values = sanitizeWithType<List<dynamic>>(
      data[AppJsonKeys.projects],
      defaultValue: <dynamic>[],
    );
    _projects = values
        .map(
          (value) => ProjectModel.fromJson(
            sanitizeWithType<Map<String, dynamic>>(
              value,
              defaultValue: <String, dynamic>{},
            ),
          ),
        )
        .toList();
  }
}
