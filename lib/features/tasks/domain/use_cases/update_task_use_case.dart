import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';
import 'package:grubpac/features/tasks/domain/params/task_params.dart';
import 'package:grubpac/features/tasks/domain/repo/i_task_repo.dart';

class UpdateTaskUseCase implements UseCase<TaskEntity, TaskRequestParams> {
  final ITaskRepo repository;

  UpdateTaskUseCase({required this.repository});

  @override
  Future<Either<Failure, TaskEntity>> call({
    required TaskRequestParams parameters,
  }) => repository.updateTask(
    request: parameters.request,
    session: parameters.session,
  );
}
