import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/common_failures.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/projects/data/data_sources/i_projects_remote_ds.dart';
import 'package:grubpac/features/projects/data/models/create_project_request_model.dart';
import 'package:grubpac/features/projects/data/models/update_project_request_model.dart';
import 'package:grubpac/features/projects/domain/entities/create_project_request_entity.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';
import 'package:grubpac/features/projects/domain/entities/update_project_request_entity.dart';
import 'package:grubpac/features/projects/domain/repo/i_projects_repo.dart';

class ProjectsRepoImpl implements IProjectsRepo {
  ProjectsRepoImpl({required this._remoteDs});

  final IProjectsRemoteDs _remoteDs;

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects({
    required UserSessionEntity session,
  }) async {
    try {
      final projects = await _remoteDs.getProjects(
        session: UserSessionModel.fromEntity(session),
      );
      return right(projects.map((project) => project.toEntity()).toList());
    } catch (error) {
      return left(DefaultFailure(message: error.toString(), cause: error));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> getProjectById({
    required String projectId,
    required UserSessionEntity session,
  }) async {
    try {
      final project = await _remoteDs.getProjectById(
        projectId: projectId,
        session: UserSessionModel.fromEntity(session),
      );
      return right(project.toEntity());
    } catch (error) {
      return left(DefaultFailure(message: error.toString(), cause: error));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> createProject({
    required CreateProjectRequestEntity request,
    required UserSessionEntity session,
  }) async {
    try {
      final project = await _remoteDs.createProject(
        request: CreateProjectRequestModel.fromEntity(request),
        session: UserSessionModel.fromEntity(session),
      );
      return right(project.toEntity());
    } catch (error) {
      return left(DefaultFailure(message: error.toString(), cause: error));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> updateProject({
    required UpdateProjectRequestEntity request,
    required UserSessionEntity session,
  }) async {
    try {
      final project = await _remoteDs.updateProject(
        request: UpdateProjectRequestModel.fromEntity(request),
        session: UserSessionModel.fromEntity(session),
      );
      return right(project.toEntity());
    } catch (error) {
      return left(DefaultFailure(message: error.toString(), cause: error));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProject({
    required String projectId,
    required UserSessionEntity session,
  }) async {
    try {
      await _remoteDs.deleteProject(
        projectId: projectId,
        session: UserSessionModel.fromEntity(session),
      );
      return right(null);
    } catch (error) {
      return left(DefaultFailure(message: error.toString(), cause: error));
    }
  }
}
