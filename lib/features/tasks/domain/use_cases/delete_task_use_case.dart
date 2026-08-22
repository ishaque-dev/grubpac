import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/tasks/domain/params/task_params.dart';
import 'package:grubpac/features/tasks/domain/repo/i_task_repo.dart';

class DeleteTaskUseCase implements UseCase<void, TaskIdParams> {
  final ITaskRepo repository;

  DeleteTaskUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call({required TaskIdParams parameters}) =>
      repository.deleteTask(
        taskId: parameters.taskId,
        session: parameters.session,
      );
}
