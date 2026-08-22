import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';
import 'package:grubpac/features/tasks/domain/params/task_params.dart';
import 'package:grubpac/features/tasks/domain/repo/i_task_repo.dart';

class AssignTaskUseCase implements UseCase<TaskEntity, AssignTaskParams> {
  final ITaskRepo repository;

  AssignTaskUseCase({required this.repository});

  @override
  Future<Either<Failure, TaskEntity>> call({
    required AssignTaskParams parameters,
  }) => repository.assignTask(
    taskId: parameters.taskId,
    assigneeId: parameters.assigneeId,
    session: parameters.session,
  );
}
