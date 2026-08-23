import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/features/projects/domain/entities/create_project_request_entity.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';
import 'package:grubpac/features/projects/domain/entities/update_project_request_entity.dart';
import 'package:grubpac/features/projects/domain/params/project_params.dart';
import 'package:grubpac/features/projects/domain/use_cases/create_project_use_case.dart';
import 'package:grubpac/features/projects/domain/use_cases/delete_project_use_case.dart';
import 'package:grubpac/features/projects/domain/use_cases/get_project_by_id_use_case.dart';
import 'package:grubpac/features/projects/domain/use_cases/get_projects_use_case.dart';
import 'package:grubpac/features/projects/domain/use_cases/update_project_use_case.dart';
import 'package:grubpac/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProjectsUseCase extends Mock implements GetProjectsUseCase {}
class MockGetProjectByIdUseCase extends Mock implements GetProjectByIdUseCase {}
class MockCreateProjectUseCase extends Mock implements CreateProjectUseCase {}
class MockUpdateProjectUseCase extends Mock implements UpdateProjectUseCase {}
class MockDeleteProjectUseCase extends Mock implements DeleteProjectUseCase {}

void main() {
  late ProjectsBloc bloc;
  late MockGetProjectsUseCase getProjects;
  late MockGetProjectByIdUseCase getProjectById;
  late MockCreateProjectUseCase createProject;
  late MockUpdateProjectUseCase updateProject;
  late MockDeleteProjectUseCase deleteProject;

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

  final tProject = ProjectEntity(
    id: '1',
    organizationId: '1',
    name: 'Project 1',
    description: 'Description 1',
    taskCount: 0,
    status: 'active',
    createdAt: tNow,
  );

  setUp(() {
    getProjects = MockGetProjectsUseCase();
    getProjectById = MockGetProjectByIdUseCase();
    createProject = MockCreateProjectUseCase();
    updateProject = MockUpdateProjectUseCase();
    deleteProject = MockDeleteProjectUseCase();

    bloc = ProjectsBloc(
      getProjects: getProjects,
      getProjectById: getProjectById,
      createProject: createProject,
      updateProject: updateProject,
      deleteProject: deleteProject,
    );

    registerFallbackValue(tSession);
    registerFallbackValue(GetProjectByIdParams(projectId: '1', session: tSession));
    registerFallbackValue(CreateProjectParams(
      request: const CreateProjectRequestEntity(name: '', description: ''),
      session: tSession,
    ));
    registerFallbackValue(UpdateProjectParams(
      request: const UpdateProjectRequestEntity(projectId: '1'),
      session: tSession,
    ));
    registerFallbackValue(DeleteProjectParams(projectId: '1', session: tSession));
  });

  test('initial state should be ProjectsInitial', () {
    expect(bloc.state, ProjectsInitial());
  });

  blocTest<ProjectsBloc, ProjectsState>(
    'emits [ProjectsLoading, ProjectsLoaded] when ProjectsLoadRequested is successful',
    build: () {
      when(() => getProjects(parameters: any(named: 'parameters')))
          .thenAnswer((_) async => right([tProject]));
      return bloc;
    },
    act: (bloc) => bloc.add(ProjectsLoadRequested(tSession)),
    expect: () => [
      ProjectsLoading(),
      ProjectsLoaded(projects: [tProject]),
    ],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'emits [ProjectsLoading, ProjectsLoaded] when ProjectLoadRequested is successful',
    build: () {
      when(() => getProjectById(parameters: any(named: 'parameters')))
          .thenAnswer((_) async => right(tProject));
      return bloc;
    },
    act: (bloc) => bloc.add(ProjectLoadRequested(projectId: '1', session: tSession)),
    expect: () => [
      ProjectsLoading(),
      ProjectsLoaded(projects: const [], selectedProject: tProject),
    ],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'emits [ProjectsLoading, ProjectsLoaded] when ProjectCreateRequested is successful',
    build: () {
      when(() => createProject(parameters: any(named: 'parameters')))
          .thenAnswer((_) async => right(tProject));
      return bloc;
    },
    act: (bloc) => bloc.add(ProjectCreateRequested(
      name: 'New',
      description: 'Desc',
      session: tSession,
    )),
    expect: () => [
      ProjectsLoading(),
      ProjectsLoaded(projects: [tProject], message: AppUiStrings.projectCreated),
    ],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'emits [ProjectsLoading, ProjectsLoaded] when ProjectUpdateRequested is successful',
    build: () {
      when(() => updateProject(parameters: any(named: 'parameters')))
          .thenAnswer((_) async => right(tProject));
      return bloc;
    },
    seed: () => ProjectsLoaded(projects: [tProject]),
    act: (bloc) => bloc.add(ProjectUpdateRequested(
      projectId: '1',
      name: 'Updated',
      session: tSession,
    )),
    expect: () => [
      ProjectsLoading(),
      ProjectsLoaded(
        projects: [tProject],
        selectedProject: tProject,
        message: AppUiStrings.projectUpdated,
      ),
    ],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'emits [ProjectsLoading, ProjectsLoaded] when ProjectDeleteRequested is successful',
    build: () {
      when(() => deleteProject(parameters: any(named: 'parameters')))
          .thenAnswer((_) async => const Right(null));
      return bloc;
    },
    act: (bloc) => bloc.add(ProjectDeleteRequested(projectId: '1', session: tSession)),
    expect: () => [
      ProjectsLoading(),
      const ProjectsLoaded(projects: [], message: AppUiStrings.projectDeleted),
    ],
  );
}
