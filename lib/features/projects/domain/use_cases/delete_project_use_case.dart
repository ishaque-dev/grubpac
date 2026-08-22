import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/projects/domain/params/project_params.dart';
import 'package:grubpac/features/projects/domain/repo/i_projects_repo.dart';

class DeleteProjectUseCase implements UseCase<void, DeleteProjectParams> {
  final IProjectsRepo repository;

  DeleteProjectUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call({
    required DeleteProjectParams parameters,
  }) {
    return repository.deleteProject(
      projectId: parameters.projectId,
      session: parameters.session,
    );
  }
}
