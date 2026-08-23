import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:grubpac/core/database/db.dart';
import 'package:grubpac/features/auth/data/data_sources/i_auth_local_ds.dart';
import 'package:grubpac/features/auth/data/data_sources/i_auth_remote_ds.dart';
import 'package:grubpac/features/auth/data/impl/auth_local_ds_impl.dart';
import 'package:grubpac/features/auth/data/impl/auth_remote_ds_impl.dart';
import 'package:grubpac/features/auth/data/impl/auth_repo_impl.dart';
import 'package:grubpac/features/auth/domain/repo/i_auth_repo.dart';
import 'package:grubpac/features/auth/domain/use_cases/get_saved_session_use_case.dart';
import 'package:grubpac/features/auth/domain/use_cases/login_use_case.dart';
import 'package:grubpac/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:grubpac/features/auth/domain/use_cases/refresh_session_use_case.dart';
import 'package:grubpac/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:grubpac/features/projects/data/data_sources/i_projects_local_ds.dart';
import 'package:grubpac/features/projects/data/data_sources/i_projects_remote_ds.dart';
import 'package:grubpac/features/projects/data/impl/projects_local_ds_impl.dart';
import 'package:grubpac/features/projects/data/impl/projects_remote_ds_impl.dart';
import 'package:grubpac/features/projects/data/impl/projects_repo_impl.dart';
import 'package:grubpac/features/projects/domain/repo/i_projects_repo.dart';
import 'package:grubpac/features/projects/domain/use_cases/create_project_use_case.dart';
import 'package:grubpac/features/projects/domain/use_cases/delete_project_use_case.dart';
import 'package:grubpac/features/projects/domain/use_cases/get_project_by_id_use_case.dart';
import 'package:grubpac/features/projects/domain/use_cases/get_projects_use_case.dart';
import 'package:grubpac/features/projects/domain/use_cases/update_project_use_case.dart';
import 'package:grubpac/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:grubpac/features/tasks/data/data_sources/i_task_local_ds.dart';
import 'package:grubpac/features/tasks/data/data_sources/i_task_remote_ds.dart';
import 'package:grubpac/features/tasks/data/impl/task_local_ds_impl.dart';
import 'package:grubpac/features/tasks/data/impl/task_remote_ds_impl.dart';
import 'package:grubpac/features/tasks/data/impl/task_repo_impl.dart';
import 'package:grubpac/features/tasks/domain/repo/i_task_repo.dart';
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
import 'package:grubpac/features/team/data/data_sources/i_team_remote_ds.dart';
import 'package:grubpac/features/team/data/impl/team_remote_ds_impl.dart';
import 'package:grubpac/features/team/data/impl/team_repo_impl.dart';
import 'package:grubpac/features/team/domain/repo/i_team_repo.dart';
import 'package:grubpac/features/team/domain/use_cases/get_members_use_case.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initCore();

  // Auth Feature
  _initAuth();

  // Tasks Feature
  _initTasks();

  // Team Feature
  _initTeam();

  // Projects Feature
  _initProjects();
}

void _initTeam() {
  serviceLocator.registerLazySingleton<ITeamRemoteDs>(TeamRemoteDsImpl.new);
  serviceLocator.registerLazySingleton<ITeamRepo>(
    () => TeamRepoImpl(remoteDs: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetMembersUseCase(repository: serviceLocator()),
  );
}

void _initCore() {
  serviceLocator.registerLazySingleton(Dio.new);
  serviceLocator.registerLazySingleton(DatabaseHelper.new);
  serviceLocator.registerLazySingleton(() => const FlutterSecureStorage());
}

void _initAuth() {
  // Data Sources
  serviceLocator.registerLazySingleton<IAuthRemoteDs>(AuthRemoteDsImpl.new);
  serviceLocator.registerLazySingleton<IAuthLocalDs>(
    () => AuthLocalDsImpl(secureStorage: serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<IAuthRepo>(
    () => AuthRepoImpl(remoteDs: serviceLocator(), localDs: serviceLocator()),
  );

  // Use Cases
  serviceLocator.registerLazySingleton(
    () => LoginUseCase(authRepo: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => LogoutUseCase(authRepo: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetSavedSessionUseCase(authRepo: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => RefreshSessionUseCase(authRepo: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => AuthBloc(
      getSavedSession: serviceLocator(),
      login: serviceLocator(),
      logout: serviceLocator(),
      refreshSession: serviceLocator(),
    ),
  );
}

void _initTasks() {
  serviceLocator.registerLazySingleton<ITaskLocalDs>(
    () => TaskLocalDsImpl(databaseHelper: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ITaskRemoteDs>(TaskRemoteDsImpl.new);
  serviceLocator.registerLazySingleton<ITaskRepo>(
    () => TaskRepoImpl(remoteDs: serviceLocator(), localDs: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetTasksUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetTaskByIdUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => CreateTaskUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateTaskUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteTaskUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateTaskStatusUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateTaskPriorityUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => AssignTaskUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UnassignTaskUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => TaskBloc(
      getTasks: serviceLocator(),
      getTaskById: serviceLocator(),
      createTask: serviceLocator(),
      updateTask: serviceLocator(),
      deleteTask: serviceLocator(),
      updateTaskStatus: serviceLocator(),
      updateTaskPriority: serviceLocator(),
      assignTask: serviceLocator(),
      unassignTask: serviceLocator(),
    ),
  );
}

void _initProjects() {
  serviceLocator.registerLazySingleton<IProjectsLocalDs>(
    () => ProjectsLocalDsImpl(databaseHelper: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<IProjectsRemoteDs>(
    ProjectsRemoteDsImpl.new,
  );
  serviceLocator.registerLazySingleton<IProjectsRepo>(
    () =>
        ProjectsRepoImpl(remoteDs: serviceLocator(), localDs: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetProjectsUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetProjectByIdUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => CreateProjectUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateProjectUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteProjectUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => ProjectsBloc(
      getProjects: serviceLocator(),
      getProjectById: serviceLocator(),
      createProject: serviceLocator(),
      updateProject: serviceLocator(),
      deleteProject: serviceLocator(),
    ),
  );
}
