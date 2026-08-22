import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/core/utils/mock_data.dart';
import 'package:grubpac/core/utils/parsing_santizer.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/tasks/data/data_sources/i_task_remote_ds.dart';
import 'package:grubpac/features/tasks/data/models/task_model.dart';
import 'package:grubpac/features/tasks/domain/entities/task_filter_entity.dart';

class TaskRemoteDsImpl implements ITaskRemoteDs {
  List<TaskModel>? _tasks;

  @override
  Future<List<TaskModel>> getTasks({
    required String projectId,
    required UserSessionModel session,
    TaskFilterEntity? filter,
  }) async {
    await _loadTasks();
    await _ensureProjectAccess(projectId, session);
    return _tasks!
        .where((task) => task.projectId == projectId)
        .where((task) => filter == null || _matchesFilter(task, filter))
        .toList(growable: false);
  }

  @override
  Future<TaskModel> getTaskById({
    required String taskId,
    required UserSessionModel session,
  }) async {
    await _loadTasks();
    final task = _findTask(taskId);
    await _ensureProjectAccess(task.projectId, session);
    return task;
  }

  @override
  Future<TaskModel> createTask({
    required TaskModel request,
    required UserSessionModel session,
  }) async {
    await _loadTasks();
    await _ensureProjectAccess(request.projectId, session);
    _tasks!.add(request);
    return request;
  }

  @override
  Future<TaskModel> updateTask({
    required TaskModel request,
    required UserSessionModel session,
  }) async {
    await _loadTasks();
    await _ensureProjectAccess(request.projectId, session);
    final index = _tasks!.indexWhere((task) => task.id == request.id);
    if (index < 0) throw StateError('Task not found');
    _tasks![index] = request;
    return request;
  }

  @override
  Future<void> deleteTask({
    required String taskId,
    required UserSessionModel session,
  }) async {
    await _loadTasks();
    final task = _findTask(taskId);
    await _ensureProjectAccess(task.projectId, session);
    final count = _tasks!.length;
    _tasks!.removeWhere((task) => task.id == taskId);
    if (count == _tasks!.length) throw StateError('Task not found');
  }

  @override
  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
    required UserSessionModel session,
  }) async {
    final task = await getTaskById(taskId: taskId, session: session);
    return updateTask(
      request: task.copyWith(status: status),
      session: session,
    );
  }

  @override
  Future<TaskModel> updateTaskPriority({
    required String taskId,
    required TaskPriority priority,
    required UserSessionModel session,
  }) async {
    final task = await getTaskById(taskId: taskId, session: session);
    return updateTask(
      request: task.copyWith(priority: priority),
      session: session,
    );
  }

  @override
  Future<TaskModel> assignTask({
    required String taskId,
    required String assigneeId,
    required UserSessionModel session,
  }) async {
    final task = await getTaskById(taskId: taskId, session: session);
    return updateTask(
      request: task.copyWith(assigneeId: assigneeId),
      session: session,
    );
  }

  @override
  Future<TaskModel> unassignTask({
    required String taskId,
    required UserSessionModel session,
  }) async {
    final task = await getTaskById(taskId: taskId, session: session);
    final updated = TaskModel(
      id: task.id,
      projectId: task.projectId,
      title: task.title,
      description: task.description,
      status: task.status,
      priority: task.priority,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
    );
    return updateTask(request: updated, session: session);
  }

  Future<void> _loadTasks() async {
    if (_tasks != null) return;
    final data = await MockApiResponse.load();
    final values = sanitizeWithType<List<dynamic>>(
      data[AppJsonKeys.tasks],
      defaultValue: <dynamic>[],
    );
    _tasks = values
        .map(
          (value) => TaskModel.fromJson(
            sanitizeWithType<Map<String, dynamic>>(
              value,
              defaultValue: <String, dynamic>{},
            ),
          ),
        )
        .toList();
  }

  TaskModel _findTask(String taskId) {
    return _tasks!.firstWhere((task) => task.id == taskId);
  }

  Future<void> _ensureProjectAccess(
    String projectId,
    UserSessionModel session,
  ) async {
    final data = await MockApiResponse.load();
    final projects = sanitizeWithType<List<dynamic>>(
      data[AppJsonKeys.projects],
      defaultValue: <dynamic>[],
    );
    final hasAccess = projects.any((value) {
      final project = sanitizeWithType<Map<String, dynamic>>(
        value,
        defaultValue: <String, dynamic>{},
      );
      return sanitizeWithType<String>(project[AppJsonKeys.id]) == projectId &&
          sanitizeWithType<String>(project[AppJsonKeys.organizationId]) ==
              session.organizationId;
    });
    if (!hasAccess) throw StateError('Project access denied');
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
