import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';
import 'package:grubpac/features/tasks/domain/entities/task_filter_entity.dart';

abstract interface class ITaskRepo {
  Future<Either<Failure, List<TaskEntity>>> getTasks({
    required String projectId,
    required UserSessionEntity session,
    TaskFilterEntity? filter,
  });

  Future<Either<Failure, TaskEntity>> getTaskById({
    required String taskId,
    required UserSessionEntity session,
  });

  Future<Either<Failure, TaskEntity>> createTask({
    required TaskEntity request,
    required UserSessionEntity session,
  });

  Future<Either<Failure, TaskEntity>> updateTask({
    required TaskEntity request,
    required UserSessionEntity session,
  });

  Future<Either<Failure, void>> deleteTask({
    required String taskId,
    required UserSessionEntity session,
  });

  Future<Either<Failure, TaskEntity>> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
    required UserSessionEntity session,
  });

  Future<Either<Failure, TaskEntity>> updateTaskPriority({
    required String taskId,
    required TaskPriority priority,
    required UserSessionEntity session,
  });

  Future<Either<Failure, TaskEntity>> assignTask({
    required String taskId,
    required String assigneeId,
    required UserSessionEntity session,
  });

  Future<Either<Failure, TaskEntity>> unassignTask({
    required String taskId,
    required UserSessionEntity session,
  });
}
