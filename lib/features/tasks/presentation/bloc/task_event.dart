part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

final class TasksLoadRequested extends TaskEvent {
  const TasksLoadRequested({
    required this.projectId,
    required this.session,
    this.filter,
  });

  final String projectId;
  final UserSessionEntity session;
  final TaskFilterEntity? filter;

  @override
  List<Object?> get props => [projectId, session, filter];
}

final class TaskLoadRequested extends TaskEvent {
  const TaskLoadRequested({required this.taskId, required this.session});

  final String taskId;
  final UserSessionEntity session;

  @override
  List<Object> get props => [taskId, session];
}

final class TaskCreateRequested extends TaskEvent {
  const TaskCreateRequested({required this.task, required this.session});

  final TaskEntity task;
  final UserSessionEntity session;

  @override
  List<Object> get props => [task, session];
}

final class TaskUpdateRequested extends TaskEvent {
  const TaskUpdateRequested({required this.task, required this.session});

  final TaskEntity task;
  final UserSessionEntity session;

  @override
  List<Object> get props => [task, session];
}

final class TaskDeleteRequested extends TaskEvent {
  const TaskDeleteRequested({required this.taskId, required this.session});

  final String taskId;
  final UserSessionEntity session;

  @override
  List<Object> get props => [taskId, session];
}

final class TaskStatusUpdateRequested extends TaskEvent {
  const TaskStatusUpdateRequested({
    required this.taskId,
    required this.status,
    required this.session,
  });

  final String taskId;
  final TaskStatus status;
  final UserSessionEntity session;

  @override
  List<Object> get props => [taskId, status, session];
}

final class TaskPriorityUpdateRequested extends TaskEvent {
  const TaskPriorityUpdateRequested({
    required this.taskId,
    required this.priority,
    required this.session,
  });

  final String taskId;
  final TaskPriority priority;
  final UserSessionEntity session;

  @override
  List<Object> get props => [taskId, priority, session];
}

final class TaskAssignRequested extends TaskEvent {
  const TaskAssignRequested({
    required this.taskId,
    required this.assigneeId,
    required this.session,
  });

  final String taskId;
  final String assigneeId;
  final UserSessionEntity session;

  @override
  List<Object> get props => [taskId, assigneeId, session];
}

final class TaskUnassignRequested extends TaskEvent {
  const TaskUnassignRequested({required this.taskId, required this.session});

  final String taskId;
  final UserSessionEntity session;

  @override
  List<Object> get props => [taskId, session];
}
