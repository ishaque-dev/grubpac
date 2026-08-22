import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';
import 'package:grubpac/features/tasks/domain/params/task_params.dart';
import 'package:grubpac/features/tasks/domain/repo/i_task_repo.dart';

class GetTasksUseCase implements UseCase<List<TaskEntity>, GetTasksParams> {
  final ITaskRepo repository;

  GetTasksUseCase({required this.repository});

  @override
  Future<Either<Failure, List<TaskEntity>>> call({
    required GetTasksParams parameters,
  }) {
    return repository.getTasks(
      projectId: parameters.projectId,
      session: parameters.session,
      filter: parameters.filter,
    );
  }
}
