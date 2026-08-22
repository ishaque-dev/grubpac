import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';
import 'package:grubpac/features/tasks/domain/entities/task_filter_entity.dart';
import 'package:grubpac/features/tasks/domain/params/task_params.dart';
import 'package:grubpac/features/tasks/domain/use_cases/assign_task_use_case.dart';
import 'package:grubpac/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:grubpac/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:grubpac/features/tasks/domain/use_cases/get_task_by_id_use_case.dart';
import 'package:grubpac/features/tasks/domain/use_cases/get_tasks_use_case.dart';
import 'package:grubpac/features/tasks/domain/use_cases/unassign_task_use_case.dart';
import 'package:grubpac/features/tasks/domain/use_cases/update_task_priority_use_case.dart';
import 'package:grubpac/features/tasks/domain/use_cases/update_task_status_use_case.dart';
import 'package:grubpac/features/tasks/domain/use_cases/update_task_use_case.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    required this._getTasks,
    required this._getTaskById,
    required this._createTask,
    required this._updateTask,
    required this._deleteTask,
    required this._updateTaskStatus,
    required this._updateTaskPriority,
    required this._assignTask,
    required this._unassignTask,
  }) : super(TaskInitial()) {
    on<TasksLoadRequested>(_onTasksLoadRequested);
    on<TaskLoadRequested>(_onTaskLoadRequested);
    on<TaskCreateRequested>(_onCreateRequested);
    on<TaskUpdateRequested>(_onUpdateRequested);
    on<TaskDeleteRequested>(_onDeleteRequested);
    on<TaskStatusUpdateRequested>(_onStatusUpdateRequested);
    on<TaskPriorityUpdateRequested>(_onPriorityUpdateRequested);
    on<TaskAssignRequested>(_onAssignRequested);
    on<TaskUnassignRequested>(_onUnassignRequested);
  }

  final GetTasksUseCase _getTasks;
  final GetTaskByIdUseCase _getTaskById;
  final CreateTaskUseCase _createTask;
  final UpdateTaskUseCase _updateTask;
  final DeleteTaskUseCase _deleteTask;
  final UpdateTaskStatusUseCase _updateTaskStatus;
  final UpdateTaskPriorityUseCase _updateTaskPriority;
  final AssignTaskUseCase _assignTask;
  final UnassignTaskUseCase _unassignTask;

  Future<void> _onTasksLoadRequested(
    TasksLoadRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    final result = await _getTasks(
      parameters: GetTasksParams(
        projectId: event.projectId,
        session: event.session,
        filter: event.filter,
      ),
    );
    result.fold(
      (failure) => emit(TaskFailure(failure.message)),
      (tasks) => emit(TaskLoaded(tasks: tasks)),
    );
  }

  Future<void> _onTaskLoadRequested(
    TaskLoadRequested event,
    Emitter<TaskState> emit,
  ) async {
    final previous = _tasks;
    emit(TaskLoading());
    final result = await _getTaskById(
      parameters: TaskIdParams(taskId: event.taskId, session: event.session),
    );
    result.fold(
      (failure) => emit(TaskFailure(failure.message, tasks: previous)),
      (task) => emit(TaskLoaded(tasks: previous, selectedTask: task)),
    );
  }

  Future<void> _onCreateRequested(
    TaskCreateRequested event,
    Emitter<TaskState> emit,
  ) async {
    final previous = _tasks;
    emit(TaskLoading());
    final result = await _createTask(
      parameters: TaskRequestParams(
        request: event.task,
        session: event.session,
      ),
    );
    result.fold(
      (failure) => emit(TaskFailure(failure.message, tasks: previous)),
      (task) =>
          emit(TaskLoaded(tasks: [...previous, task], selectedTask: task)),
    );
  }

  Future<void> _onUpdateRequested(
    TaskUpdateRequested event,
    Emitter<TaskState> emit,
  ) async {
    await _runTaskMutation(
      emit,
      () => _updateTask(
        parameters: TaskRequestParams(
          request: event.task,
          session: event.session,
        ),
      ),
    );
  }

  Future<void> _onDeleteRequested(
    TaskDeleteRequested event,
    Emitter<TaskState> emit,
  ) async {
    final previous = _tasks;
    emit(TaskLoading());
    final result = await _deleteTask(
      parameters: TaskIdParams(taskId: event.taskId, session: event.session),
    );
    result.fold(
      (failure) => emit(TaskFailure(failure.message, tasks: previous)),
      (_) => emit(
        TaskLoaded(
          tasks: previous.where((task) => task.id != event.taskId).toList(),
        ),
      ),
    );
  }

  Future<void> _onStatusUpdateRequested(
    TaskStatusUpdateRequested event,
    Emitter<TaskState> emit,
  ) async {
    await _runTaskMutation(
      emit,
      () => _updateTaskStatus(
        parameters: UpdateTaskStatusParams(
          taskId: event.taskId,
          status: event.status,
          session: event.session,
        ),
      ),
    );
  }

  Future<void> _onPriorityUpdateRequested(
    TaskPriorityUpdateRequested event,
    Emitter<TaskState> emit,
  ) async {
    await _runTaskMutation(
      emit,
      () => _updateTaskPriority(
        parameters: UpdateTaskPriorityParams(
          taskId: event.taskId,
          priority: event.priority,
          session: event.session,
        ),
      ),
    );
  }

  Future<void> _onAssignRequested(
    TaskAssignRequested event,
    Emitter<TaskState> emit,
  ) async {
    await _runTaskMutation(
      emit,
      () => _assignTask(
        parameters: AssignTaskParams(
          taskId: event.taskId,
          assigneeId: event.assigneeId,
          session: event.session,
        ),
      ),
    );
  }

  Future<void> _onUnassignRequested(
    TaskUnassignRequested event,
    Emitter<TaskState> emit,
  ) async {
    await _runTaskMutation(
      emit,
      () => _unassignTask(
        parameters: TaskIdParams(taskId: event.taskId, session: event.session),
      ),
    );
  }

  Future<void> _runTaskMutation(
    Emitter<TaskState> emit,
    Future<dynamic> Function() operation,
  ) async {
    final previous = _tasks;
    emit(TaskLoading());
    final result = await operation();
    result.fold(
      (failure) => emit(TaskFailure(failure.message, tasks: previous)),
      (task) => emit(
        TaskLoaded(
          tasks: [
            for (final current in previous)
              if (current.id == task.id) task else current,
          ],
          selectedTask: task,
        ),
      ),
    );
  }

  List<TaskEntity> get _tasks => state is TaskLoaded
      ? (state as TaskLoaded).tasks
      : state is TaskFailure
      ? (state as TaskFailure).tasks
      : const <TaskEntity>[];
}
