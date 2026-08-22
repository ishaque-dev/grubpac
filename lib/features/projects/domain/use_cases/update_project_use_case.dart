import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/common_failures.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/shared/enums.dart';
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
    if (parameters.session.role != UserRole.orgAdmin) {
      return Future.value(
        left(
          ForbiddenFailure(
            message: 'Only organization admins can update projects.',
          ),
        ),
      );
    }
    return repository.updateProject(
      request: parameters.request,
      session: parameters.session,
    );
  }
}
