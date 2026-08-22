import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';
import 'package:grubpac/features/projects/domain/params/project_params.dart';
import 'package:grubpac/features/projects/domain/repo/i_projects_repo.dart';

class CreateProjectUseCase
    implements UseCase<ProjectEntity, CreateProjectParams> {
  final IProjectsRepo repository;

  CreateProjectUseCase({required this.repository});

  @override
  Future<Either<Failure, ProjectEntity>> call({
    required CreateProjectParams parameters,
  }) {
    return repository.createProject(
      request: parameters.request,
      session: parameters.session,
    );
  }
}
