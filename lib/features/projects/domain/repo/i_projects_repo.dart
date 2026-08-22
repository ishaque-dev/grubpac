import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/features/projects/domain/entities/create_project_request_entity.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart'
    show ProjectEntity;
import 'package:grubpac/features/projects/domain/entities/update_project_request_entity.dart';

abstract interface class IProjectsRepo {
  Future<Either<Failure, List<ProjectEntity>>> getProjects({
    required UserSessionEntity session,
  });

  Future<Either<Failure, ProjectEntity>> getProjectById({
    required String projectId,
    required UserSessionEntity session,
  });

  Future<Either<Failure, ProjectEntity>> createProject({
    required CreateProjectRequestEntity request,
    required UserSessionEntity session,
  });

  Future<Either<Failure, ProjectEntity>> updateProject({
    required UpdateProjectRequestEntity request,
    required UserSessionEntity session,
  });

  Future<Either<Failure, void>> deleteProject({
    required String projectId,
    required UserSessionEntity session,
  });
}
