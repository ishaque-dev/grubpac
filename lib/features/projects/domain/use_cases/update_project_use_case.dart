import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';
import 'package:grubpac/features/projects/domain/params/project_params.dart';
import 'package:grubpac/features/projects/domain/repo/i_projects_repo.dart';

class UpdateProjectUseCase
    implements UseCase<ProjectEntity, UpdateProjectParams> {
  final IProjectsRepo repository;

  UpdateProjectUseCase({required this.repository});

  @override
  Future<Either<Failure, ProjectEntity>> call({
    required UpdateProjectParams parameters,
  }) {
    return repository.updateProject(
      request: parameters.request,
      session: parameters.session,
    );
  }
}
