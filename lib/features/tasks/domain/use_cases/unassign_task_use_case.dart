import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';
import 'package:grubpac/features/tasks/domain/params/task_params.dart';
import 'package:grubpac/features/tasks/domain/repo/i_task_repo.dart';

class UnassignTaskUseCase implements UseCase<TaskEntity, TaskIdParams> {
  final ITaskRepo repository;

  UnassignTaskUseCase({required this.repository});

  @override
  Future<Either<Failure, TaskEntity>> call({
    required TaskIdParams parameters,
  }) => repository.unassignTask(
    taskId: parameters.taskId,
    session: parameters.session,
  );
}
