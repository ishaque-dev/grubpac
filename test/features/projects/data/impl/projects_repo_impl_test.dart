import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/projects/data/data_sources/i_projects_local_ds.dart';
import 'package:grubpac/features/projects/data/data_sources/i_projects_remote_ds.dart';
import 'package:grubpac/features/projects/data/impl/projects_repo_impl.dart';
import 'package:grubpac/features/projects/data/models/create_project_request_model.dart';
import 'package:grubpac/features/projects/data/models/project_model.dart';
import 'package:grubpac/features/projects/data/models/update_project_request_model.dart';
import 'package:grubpac/features/projects/domain/entities/create_project_request_entity.dart';
import 'package:grubpac/features/projects/domain/entities/update_project_request_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockProjectsRemoteDs extends Mock implements IProjectsRemoteDs {}
class MockProjectsLocalDs extends Mock implements IProjectsLocalDs {}

void main() {
  late ProjectsRepoImpl repo;
  late MockProjectsRemoteDs remoteDs;
  late MockProjectsLocalDs localDs;

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

  final tProjectModel = ProjectModel(
    id: '1',
    organizationId: '1',
    name: 'Project 1',
    description: 'Description 1',
    taskCount: 0,
    status: 'active',
    createdAt: tNow,
  );

  final tProjectEntity = tProjectModel.toEntity();

  setUp(() {
    remoteDs = MockProjectsRemoteDs();
    localDs = MockProjectsLocalDs();
    repo = ProjectsRepoImpl(remoteDs: remoteDs, localDs: localDs);

    registerFallbackValue(UserSessionModel.fromEntity(tSession));
    registerFallbackValue(tProjectModel);
    registerFallbackValue(CreateProjectRequestModel.fromEntity(
      const CreateProjectRequestEntity(name: '', description: ''),
    ));
    registerFallbackValue(UpdateProjectRequestModel.fromEntity(
      const UpdateProjectRequestEntity(projectId: ''),
    ));
  });

  group('getProjects', () {
    test('should return remote projects when remote call is successful', () async {
      when(() => remoteDs.getProjects(session: any(named: 'session')))
          .thenAnswer((_) async => [tProjectModel]);
      when(() => localDs.saveProjects(projects: any(named: 'projects')))
          .thenAnswer((_) async => {});

      final result = await repo.getProjects(session: tSession);

      expect(result.isRight(), true);
      expect(result.getOrElse((_) => []), [tProjectEntity]);
      verify(() => remoteDs.getProjects(session: any(named: 'session'))).called(1);
      verify(() => localDs.saveProjects(projects: [tProjectModel])).called(1);
    });

    test('should return local projects when remote call fails', () async {
      when(() => remoteDs.getProjects(session: any(named: 'session')))
          .thenThrow(Exception('Remote failure'));
      when(() => localDs.getProjects(session: any(named: 'session')))
          .thenAnswer((_) async => [tProjectModel]);

      final result = await repo.getProjects(session: tSession);

      expect(result.isRight(), true);
      expect(result.getOrElse((_) => []), [tProjectEntity]);
      verify(() => remoteDs.getProjects(session: any(named: 'session'))).called(1);
      verify(() => localDs.getProjects(session: any(named: 'session'))).called(1);
    });
  });

  group('getProjectById', () {
    test('should return remote project when remote call is successful', () async {
      when(() => remoteDs.getProjectById(
            projectId: any(named: 'projectId'),
            session: any(named: 'session'),
          )).thenAnswer((_) async => tProjectModel);
      when(() => localDs.saveProject(project: any(named: 'project')))
          .thenAnswer((_) async => {});

      final result = await repo.getProjectById(projectId: '1', session: tSession);

      expect(result, Right<Failure, ProjectEntity>(tProjectEntity));
      verify(() => remoteDs.getProjectById(
            projectId: '1',
            session: any(named: 'session'),
          )).called(1);
      verify(() => localDs.saveProject(project: tProjectModel)).called(1);
    });
  });

  group('createProject', () {
    test('should return created project from remote', () async {
      const tRequest = CreateProjectRequestEntity(name: 'New', description: 'Desc');
      when(() => remoteDs.createProject(
            request: any(named: 'request'),
            session: any(named: 'session'),
          )).thenAnswer((_) async => tProjectModel);
      when(() => localDs.saveProject(project: any(named: 'project')))
          .thenAnswer((_) async => {});

      final result = await repo.createProject(request: tRequest, session: tSession);

      expect(result, Right<Failure, ProjectEntity>(tProjectEntity));
    });
  });

  group('updateProject', () {
    test('should return updated project from remote', () async {
      const tRequest = UpdateProjectRequestEntity(projectId: '1', name: 'Updated');
      when(() => remoteDs.updateProject(
            request: any(named: 'request'),
            session: any(named: 'session'),
          )).thenAnswer((_) async => tProjectModel);
      when(() => localDs.saveProject(project: any(named: 'project')))
          .thenAnswer((_) async => {});

      final result = await repo.updateProject(request: tRequest, session: tSession);

      expect(result, Right<Failure, ProjectEntity>(tProjectEntity));
    });
  });

  group('deleteProject', () {
    test('should return null on success', () async {
      when(() => remoteDs.deleteProject(
            projectId: any(named: 'projectId'),
            session: any(named: 'session'),
          )).thenAnswer((_) async => {});
      when(() => localDs.deleteProject(projectId: any(named: 'projectId')))
          .thenAnswer((_) async => {});

      final result = await repo.deleteProject(projectId: '1', session: tSession);

      expect(result, right(null));
      verify(() => remoteDs.deleteProject(
            projectId: '1',
            session: any(named: 'session'),
          )).called(1);
      verify(() => localDs.deleteProject(projectId: '1')).called(1);
    });
  });
}
