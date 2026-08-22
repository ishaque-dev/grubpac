import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/common_failures.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/tasks/data/data_sources/i_task_local_ds.dart';
import 'package:grubpac/features/tasks/data/data_sources/i_task_remote_ds.dart';
import 'package:grubpac/features/tasks/data/models/task_model.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';
import 'package:grubpac/features/tasks/domain/entities/task_filter_entity.dart';
import 'package:grubpac/features/tasks/domain/repo/i_task_repo.dart';

class TaskRepoImpl implements ITaskRepo {
  TaskRepoImpl({required this._remoteDs, required this._localDs});

  final ITaskRemoteDs _remoteDs;
  final ITaskLocalDs _localDs;

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks({
    required String projectId,
    required UserSessionEntity session,
    TaskFilterEntity? filter,
  }) async {
    final sessionModel = UserSessionModel.fromEntity(session);
    try {
      final tasks = await _remoteDs.getTasks(
        projectId: projectId,
        session: sessionModel,
        filter: filter,
      );
      await _localDs.saveTasks(tasks: tasks);
      return right(tasks.map((task) => task.toEntity()).toList());
    } catch (error) {
      try {
        final tasks = await _localDs.getTasks(
          projectId: projectId,
          session: sessionModel,
        );
        return right(
          tasks
              .where((task) => filter == null || _matchesFilter(task, filter))
              .map((task) => task.toEntity())
              .toList(),
        );
      } catch (cacheError) {
        return left(
          DefaultFailure(message: cacheError.toString(), cause: error),
        );
      }
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> getTaskById({
    required String taskId,
    required UserSessionEntity session,
  }) async {
    final sessionModel = UserSessionModel.fromEntity(session);
    try {
      final task = await _remoteDs.getTaskById(
        taskId: taskId,
        session: sessionModel,
      );
      await _localDs.saveTask(task: task);
      return right(task.toEntity());
    } catch (error) {
      try {
        final task = await _localDs.getTaskById(
          taskId: taskId,
          session: sessionModel,
        );
        if (task == null) throw StateError('Task not found');
        return right(task.toEntity());
      } catch (cacheError) {
        return left(
          DefaultFailure(message: cacheError.toString(), cause: error),
        );
      }
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask({
    required TaskEntity request,
    required UserSessionEntity session,
  }) => _write(
    () => _remoteDs.createTask(
      request: TaskModel.fromEntity(request),
      session: UserSessionModel.fromEntity(session),
    ),
  );

  @override
  Future<Either<Failure, TaskEntity>> updateTask({
    required TaskEntity request,
    required UserSessionEntity session,
  }) => _write(
    () => _remoteDs.updateTask(
      request: TaskModel.fromEntity(request),
      session: UserSessionModel.fromEntity(session),
    ),
  );

  @override
  Future<Either<Failure, void>> deleteTask({
    required String taskId,
    required UserSessionEntity session,
  }) async {
    try {
      await _remoteDs.deleteTask(
        taskId: taskId,
        session: UserSessionModel.fromEntity(session),
      );
      await _localDs.deleteTask(taskId: taskId);
      return right(null);
    } catch (error) {
      return left(DefaultFailure(message: error.toString(), cause: error));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
    required UserSessionEntity session,
  }) => _write(
    () => _remoteDs.updateTaskStatus(
      taskId: taskId,
      status: status,
      session: UserSessionModel.fromEntity(session),
    ),
  );

  @override
  Future<Either<Failure, TaskEntity>> updateTaskPriority({
    required String taskId,
    required TaskPriority priority,
    required UserSessionEntity session,
  }) => _write(
    () => _remoteDs.updateTaskPriority(
      taskId: taskId,
      priority: priority,
      session: UserSessionModel.fromEntity(session),
    ),
  );

  @override
  Future<Either<Failure, TaskEntity>> assignTask({
    required String taskId,
    required String assigneeId,
    required UserSessionEntity session,
  }) => _write(
    () => _remoteDs.assignTask(
      taskId: taskId,
      assigneeId: assigneeId,
      session: UserSessionModel.fromEntity(session),
    ),
  );

  @override
  Future<Either<Failure, TaskEntity>> unassignTask({
    required String taskId,
    required UserSessionEntity session,
  }) => _write(
    () => _remoteDs.unassignTask(
      taskId: taskId,
      session: UserSessionModel.fromEntity(session),
    ),
  );

  Future<Either<Failure, TaskEntity>> _write(
    Future<TaskModel> Function() operation,
  ) async {
    try {
      final task = await operation();
      await _localDs.saveTask(task: task);
      return right(task.toEntity());
    } catch (error) {
      return left(DefaultFailure(message: error.toString(), cause: error));
    }
  }

  bool _matchesFilter(TaskModel task, TaskFilterEntity filter) {
    return (filter.status == null || task.status == filter.status) &&
        (filter.priority == null || task.priority == filter.priority) &&
        (filter.assigneeId == null || task.assigneeId == filter.assigneeId) &&
        (filter.dueDateFrom == null ||
            !task.dueDate.isBefore(filter.dueDateFrom!)) &&
        (filter.dueDateTo == null || !task.dueDate.isAfter(filter.dueDateTo!));
  }
}
