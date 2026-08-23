import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';
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
import 'package:grubpac/features/tasks/presentation/bloc/task_bloc.dart';

class MockGetTasksUseCase extends Mock implements GetTasksUseCase {}
class MockGetTaskByIdUseCase extends Mock implements GetTaskByIdUseCase {}
class MockCreateTaskUseCase extends Mock implements CreateTaskUseCase {}
class MockUpdateTaskUseCase extends Mock implements UpdateTaskUseCase {}
class MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}
class MockUpdateTaskStatusUseCase extends Mock implements UpdateTaskStatusUseCase {}
class MockUpdateTaskPriorityUseCase extends Mock implements UpdateTaskPriorityUseCase {}
class MockAssignTaskUseCase extends Mock implements AssignTaskUseCase {}
class MockUnassignTaskUseCase extends Mock implements UnassignTaskUseCase {}

void main() {
  late TaskBloc bloc;
  late MockGetTasksUseCase getTasks;
  late MockGetTaskByIdUseCase getTaskById;
  late MockCreateTaskUseCase createTask;
  late MockUpdateTaskUseCase updateTask;
  late MockDeleteTaskUseCase deleteTask;
  late MockUpdateTaskStatusUseCase updateTaskStatus;
  late MockUpdateTaskPriorityUseCase updateTaskPriority;
  late MockAssignTaskUseCase assignTask;
  late MockUnassignTaskUseCase unassignTask;

  final tSession = UserSessionEntity(
    userId: '1',
    organizationId: '1',
    role: UserRole.orgAdmin,
    accessToken: 'access',
    refreshToken: 'refresh',
    accessTokenExpiresAt: DateTime.now().add(const Duration(hours: 1)),
    refreshTokenExpiresAt: DateTime.now().add(const Duration(days: 1)),
  );

  final tTask = TaskEntity(
    id: '1',
    projectId: '1',
    title: 'Task 1',
    description: 'Description 1',
    status: TaskStatus.todo,
    priority: TaskPriority.medium,
    dueDate: DateTime.now(),
  );

  setUp(() {
    getTasks = MockGetTasksUseCase();
    getTaskById = MockGetTaskByIdUseCase();
    createTask = MockCreateTaskUseCase();
    updateTask = MockUpdateTaskUseCase();
    deleteTask = MockDeleteTaskUseCase();
    updateTaskStatus = MockUpdateTaskStatusUseCase();
    updateTaskPriority = MockUpdateTaskPriorityUseCase();
    assignTask = MockAssignTaskUseCase();
    unassignTask = MockUnassignTaskUseCase();

    bloc = TaskBloc(
      getTasks: getTasks,
      getTaskById: getTaskById,
      createTask: createTask,
      updateTask: updateTask,
      deleteTask: deleteTask,
      updateTaskStatus: updateTaskStatus,
      updateTaskPriority: updateTaskPriority,
      assignTask: assignTask,
      unassignTask: unassignTask,
    );

    registerFallbackValue(tSession);
    registerFallbackValue(GetTasksParams(projectId: '1', session: tSession));
    registerFallbackValue(TaskIdParams(taskId: '1', session: tSession));
    registerFallbackValue(TaskRequestParams(request: tTask, session: tSession));
    registerFallbackValue(UpdateTaskStatusParams(taskId: '1', session: tSession, status: TaskStatus.done));
    registerFallbackValue(UpdateTaskPriorityParams(taskId: '1', session: tSession, priority: TaskPriority.high));
    registerFallbackValue(AssignTaskParams(taskId: '1', session: tSession, assigneeId: 'user1'));
  });

  test('initial state should be TaskInitial', () {
    expect(bloc.state, TaskInitial());
  });

  blocTest<TaskBloc, TaskState>(
    'emits [TaskLoading, TaskLoaded] when TasksLoadRequested is successful',
    build: () {
      when(() => getTasks(parameters: any(named: 'parameters')))
          .thenAnswer((_) async => right([tTask]));
      return bloc;
    },
    act: (bloc) => bloc.add(TasksLoadRequested(projectId: '1', session: tSession)),
    expect: () => [
      TaskLoading(),
      TaskLoaded(tasks: [tTask]),
    ],
  );

  blocTest<TaskBloc, TaskState>(
    'emits [TaskLoading, TaskLoaded] when TaskCreateRequested is successful',
    build: () {
      when(() => createTask(parameters: any(named: 'parameters')))
          .thenAnswer((_) async => right(tTask));
      return bloc;
    },
    act: (bloc) => bloc.add(TaskCreateRequested(task: tTask, session: tSession)),
    expect: () => [
      TaskLoading(),
      TaskLoaded(
        tasks: [tTask],
        selectedTask: tTask,
        message: AppUiStrings.taskCreated,
      ),
    ],
  );

  blocTest<TaskBloc, TaskState>(
    'emits [TaskLoading, TaskLoaded] when TaskStatusUpdateRequested is successful',
    build: () {
      final updatedTask = tTask.copyWith(status: TaskStatus.done);
      when(() => updateTaskStatus(parameters: any(named: 'parameters')))
          .thenAnswer((_) async => right(updatedTask));
      return bloc;
    },
    seed: () => TaskLoaded(tasks: [tTask]),
    act: (bloc) => bloc.add(TaskStatusUpdateRequested(
      taskId: '1',
      status: TaskStatus.done,
      session: tSession,
    )),
    expect: () => [
      TaskLoading(),
      TaskLoaded(
        tasks: [tTask.copyWith(status: TaskStatus.done)],
        selectedTask: tTask.copyWith(status: TaskStatus.done),
        message: AppUiStrings.taskStatusUpdated,
      ),
    ],
  );
}
