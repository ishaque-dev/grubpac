import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';
import 'package:grubpac/features/projects/domain/repo/i_projects_repo.dart';

class GetProjectsUseCase
    implements UseCase<List<ProjectEntity>, UserSessionEntity> {
  final IProjectsRepo repository;

  GetProjectsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ProjectEntity>>> call({
    required UserSessionEntity parameters,
  }) {
    return repository.getProjects(session: parameters);
  }
}
