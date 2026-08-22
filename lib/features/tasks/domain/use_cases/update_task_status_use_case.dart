import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';
import 'package:grubpac/features/tasks/domain/params/task_params.dart';
import 'package:grubpac/features/tasks/domain/repo/i_task_repo.dart';

class UpdateTaskStatusUseCase
    implements UseCase<TaskEntity, UpdateTaskStatusParams> {
  final ITaskRepo repository;

  UpdateTaskStatusUseCase({required this.repository});

  @override
  Future<Either<Failure, TaskEntity>> call({
    required UpdateTaskStatusParams parameters,
  }) => repository.updateTaskStatus(
    taskId: parameters.taskId,
    status: parameters.status,
    session: parameters.session,
  );
}
