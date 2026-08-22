import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';
import 'package:grubpac/features/tasks/domain/entities/task_filter_entity.dart';

class GetTasksParams {
  final String projectId;
  final UserSessionEntity session;
  final TaskFilterEntity? filter;

  const GetTasksParams({
    required this.projectId,
    required this.session,
    this.filter,
  });
}

class TaskIdParams {
  final String taskId;
  final UserSessionEntity session;

  const TaskIdParams({required this.taskId, required this.session});
}

class TaskRequestParams {
  final TaskEntity request;
  final UserSessionEntity session;

  const TaskRequestParams({required this.request, required this.session});
}

class UpdateTaskStatusParams extends TaskIdParams {
  final TaskStatus status;

  const UpdateTaskStatusParams({
    required super.taskId,
    required super.session,
    required this.status,
  });
}

class UpdateTaskPriorityParams extends TaskIdParams {
  final TaskPriority priority;

  const UpdateTaskPriorityParams({
    required super.taskId,
    required super.session,
    required this.priority,
  });
}

class AssignTaskParams extends TaskIdParams {
  final String assigneeId;

  const AssignTaskParams({
    required super.taskId,
    required super.session,
    required this.assigneeId,
  });
}
