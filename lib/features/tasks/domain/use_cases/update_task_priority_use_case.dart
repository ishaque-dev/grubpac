import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';
import 'package:grubpac/features/tasks/domain/params/task_params.dart';
import 'package:grubpac/features/tasks/domain/repo/i_task_repo.dart';

class UpdateTaskPriorityUseCase
    implements UseCase<TaskEntity, UpdateTaskPriorityParams> {
  final ITaskRepo repository;

  UpdateTaskPriorityUseCase({required this.repository});

  @override
  Future<Either<Failure, TaskEntity>> call({
    required UpdateTaskPriorityParams parameters,
  }) => repository.updateTaskPriority(
    taskId: parameters.taskId,
    priority: parameters.priority,
    session: parameters.session,
  );
}
