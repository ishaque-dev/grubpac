import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/projects/data/models/create_project_request_model.dart';
import 'package:grubpac/features/projects/data/models/project_model.dart';
import 'package:grubpac/features/projects/data/models/update_project_request_model.dart';

abstract interface class IProjectsRemoteDs {
  Future<List<ProjectModel>> getProjects({required UserSessionModel session});

  Future<ProjectModel> getProjectById({
    required String projectId,
    required UserSessionModel session,
  });

  Future<ProjectModel> createProject({
    required CreateProjectRequestModel request,
    required UserSessionModel session,
  });

  Future<ProjectModel> updateProject({
    required UpdateProjectRequestModel request,
    required UserSessionModel session,
  });

  Future<void> deleteProject({
    required String projectId,
    required UserSessionModel session,
  });
}
