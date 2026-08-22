import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/projects/data/models/project_model.dart';

abstract interface class IProjectsLocalDs {
  Future<List<ProjectModel>> getProjects({required UserSessionModel session});

  Future<void> saveProjects({required List<ProjectModel> projects});

  Future<void> saveProject({required ProjectModel project});

  Future<void> deleteProject({required String projectId});
}
