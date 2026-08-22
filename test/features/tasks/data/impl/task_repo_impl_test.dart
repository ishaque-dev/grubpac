import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/tasks/data/data_sources/i_task_local_ds.dart';
import 'package:grubpac/features/tasks/data/data_sources/i_task_remote_ds.dart';
import 'package:grubpac/features/tasks/data/impl/task_repo_impl.dart';
import 'package:grubpac/features/tasks/data/models/task_model.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';

class MockTaskRemoteDs extends Mock implements ITaskRemoteDs {}
class MockTaskLocalDs extends Mock implements ITaskLocalDs {}

void main() {
  late TaskRepoImpl repo;
  late MockTaskRemoteDs remoteDs;
  late MockTaskLocalDs localDs;

  final tNow = DateTime(2024, 1, 1);
  final tSession = UserSessionEntity(
    userId: '1',
    organizationId: '1',
    role: UserRole.orgAdmin,
    accessToken: 'access',
    refreshToken: 'refresh',
    accessTokenExpiresAt: tNow.add(const Duration(hours: 1)),
    refreshTokenExpiresAt: tNow.add(const Duration(days: 1)),
  );

  final tTaskModel = TaskModel(
    id: '1',
    projectId: '1',
    title: 'Task 1',
    description: 'Description 1',
    status: TaskStatus.todo,
    priority: TaskPriority.medium,
    dueDate: tNow,
    createdAt: tNow,
  );

  final tTaskEntity = tTaskModel.toEntity();

  setUp(() {
    remoteDs = MockTaskRemoteDs();
    localDs = MockTaskLocalDs();
    repo = TaskRepoImpl(remoteDs: remoteDs, localDs: localDs);

    registerFallbackValue(UserSessionModel.fromEntity(tSession));
    registerFallbackValue(tTaskModel);
    registerFallbackValue(TaskStatus.todo);
    registerFallbackValue(TaskPriority.medium);
  });

  group('getTasks', () {
    test('should return remote tasks when remote call is successful', () async {
      when(() => remoteDs.getTasks(
            projectId: any(named: 'projectId'),
            session: any(named: 'session'),
            filter: any(named: 'filter'),
          )).thenAnswer((_) async => [tTaskModel]);
      when(() => localDs.saveTasks(tasks: any(named: 'tasks')))
          .thenAnswer((_) async => {});

      final result = await repo.getTasks(projectId: '1', session: tSession);

      expect(result.isRight(), true);
      expect(result.getOrElse((_) => []), [tTaskEntity]);
      verify(() => remoteDs.getTasks(
            projectId: '1',
            session: any(named: 'session'),
          )).called(1);
      verify(() => localDs.saveTasks(tasks: [tTaskModel])).called(1);
    });
  });

  group('createTask', () {
    test('should return created task from remote', () async {
      when(() => remoteDs.createTask(
            request: any(named: 'request'),
            session: any(named: 'session'),
          )).thenAnswer((_) async => tTaskModel);
      when(() => localDs.saveTask(task: any(named: 'task')))
          .thenAnswer((_) async => {});

      final result = await repo.createTask(request: tTaskEntity, session: tSession);

      expect(result, Right<Failure, TaskEntity>(tTaskEntity));
    });
  });

  group('updateTaskStatus', () {
    test('should return updated task from remote', () async {
      when(() => remoteDs.updateTaskStatus(
            taskId: any(named: 'taskId'),
            status: any(named: 'status'),
            session: any(named: 'session'),
          )).thenAnswer((_) async => tTaskModel.copyWith(status: TaskStatus.done));
      when(() => localDs.saveTask(task: any(named: 'task')))
          .thenAnswer((_) async => {});

      final result = await repo.updateTaskStatus(
        taskId: '1',
        status: TaskStatus.done,
        session: tSession,
      );

      expect(result, Right<Failure, TaskEntity>(tTaskEntity.copyWith(status: TaskStatus.done)));
    });
  });
}
