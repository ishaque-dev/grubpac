import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/common_failures.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/projects/data/data_sources/i_projects_local_ds.dart';
import 'package:grubpac/features/projects/data/data_sources/i_projects_remote_ds.dart';
import 'package:grubpac/features/projects/data/models/create_project_request_model.dart';
import 'package:grubpac/features/projects/data/models/update_project_request_model.dart';
import 'package:grubpac/features/projects/domain/entities/create_project_request_entity.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';
import 'package:grubpac/features/projects/domain/entities/update_project_request_entity.dart';
import 'package:grubpac/features/projects/domain/repo/i_projects_repo.dart';

class ProjectsRepoImpl implements IProjectsRepo {
  ProjectsRepoImpl({required this._remoteDs, required this._localDs});

  final IProjectsRemoteDs _remoteDs;
  final IProjectsLocalDs _localDs;

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects({
    required UserSessionEntity session,
  }) async {
    final sessionModel = UserSessionModel.fromEntity(session);
    try {
      final projects = await _remoteDs.getProjects(session: sessionModel);
      await _localDs.saveProjects(projects: projects);
      return right(projects.map((project) => project.toEntity()).toList());
    } catch (error) {
      try {
        final projects = await _localDs.getProjects(session: sessionModel);
        return right(projects.map((project) => project.toEntity()).toList());
      } catch (cacheError) {
        return left(
          DefaultFailure(message: cacheError.toString(), cause: error),
        );
      }
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> getProjectById({
    required String projectId,
    required UserSessionEntity session,
  }) async {
    final sessionModel = UserSessionModel.fromEntity(session);
    try {
      final project = await _remoteDs.getProjectById(
        projectId: projectId,
        session: sessionModel,
      );
      await _localDs.saveProject(project: project);
      return right(project.toEntity());
    } catch (error) {
      try {
        final projects = await _localDs.getProjects(session: sessionModel);
        return right(
          projects.firstWhere((project) => project.id == projectId).toEntity(),
        );
      } catch (cacheError) {
        return left(
          DefaultFailure(message: cacheError.toString(), cause: error),
        );
      }
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> createProject({
    required CreateProjectRequestEntity request,
    required UserSessionEntity session,
  }) async {
    final sessionModel = UserSessionModel.fromEntity(session);
    try {
      final project = await _remoteDs.createProject(
        request: CreateProjectRequestModel.fromEntity(request),
        session: sessionModel,
      );
      await _localDs.saveProject(project: project);
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
    final sessionModel = UserSessionModel.fromEntity(session);
    try {
      final project = await _remoteDs.updateProject(
        request: UpdateProjectRequestModel.fromEntity(request),
        session: sessionModel,
      );
      await _localDs.saveProject(project: project);
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
    final sessionModel = UserSessionModel.fromEntity(session);
    try {
      await _remoteDs.deleteProject(
        projectId: projectId,
        session: sessionModel,
      );
      await _localDs.deleteProject(projectId: projectId);
      return right(null);
    } catch (error) {
      return left(DefaultFailure(message: error.toString(), cause: error));
    }
  }
}
