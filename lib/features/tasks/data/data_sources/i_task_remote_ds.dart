import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/tasks/data/models/task_model.dart';
import 'package:grubpac/features/tasks/domain/entities/task_filter_entity.dart';

abstract interface class ITaskRemoteDs {
  Future<List<TaskModel>> getTasks({
    required String projectId,
    required UserSessionModel session,
    TaskFilterEntity? filter,
  });

  Future<TaskModel> getTaskById({
    required String taskId,
    required UserSessionModel session,
  });

  Future<TaskModel> createTask({
    required TaskModel request,
    required UserSessionModel session,
  });

  Future<TaskModel> updateTask({
    required TaskModel request,
    required UserSessionModel session,
  });

  Future<void> deleteTask({
    required String taskId,
    required UserSessionModel session,
  });

  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
    required UserSessionModel session,
  });

  Future<TaskModel> updateTaskPriority({
    required String taskId,
    required TaskPriority priority,
    required UserSessionModel session,
  });

  Future<TaskModel> assignTask({
    required String taskId,
    required String assigneeId,
    required UserSessionModel session,
  });

  Future<TaskModel> unassignTask({
    required String taskId,
    required UserSessionModel session,
  });
}
