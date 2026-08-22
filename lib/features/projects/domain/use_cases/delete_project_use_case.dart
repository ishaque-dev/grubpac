import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/common_failures.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/shared/enums.dart';
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
    if (parameters.session.role != UserRole.orgAdmin) {
      return Future.value(
        left(
          ForbiddenFailure(
            message: 'Only organization admins can delete projects.',
          ),
        ),
      );
    }
    return repository.deleteProject(
      projectId: parameters.projectId,
      session: parameters.session,
    );
  }
}
