import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';
import 'package:grubpac/features/projects/domain/params/project_params.dart';
import 'package:grubpac/features/projects/domain/repo/i_projects_repo.dart';

class GetProjectByIdUseCase
    implements UseCase<ProjectEntity, GetProjectByIdParams> {
  final IProjectsRepo repository;

  GetProjectByIdUseCase({required this.repository});

  @override
  Future<Either<Failure, ProjectEntity>> call({
    required GetProjectByIdParams parameters,
  }) {
    return repository.getProjectById(
      projectId: parameters.projectId,
      session: parameters.session,
    );
  }
}
