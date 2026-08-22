import 'package:get_it/get_it.dart';
import 'package:grubpac/core/database/db.dart';
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

final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Auth Feature
  _initAuth();

  // Tasks Feature
  _initTasks();

  // Projects Feature
  _initProjects();
}

void _initAuth() {
  // Data Sources
  // serviceLocator.registerLazySingleton<IAuthRemoteDs>(
  //   () => AuthRemoteDsImpl(serviceLocator()),
  // );
  // serviceLocator.registerLazySingleton<IAuthLocalDs>(
  //   () => AuthLocalDsImpl(serviceLocator()),
  // );

  // // Repository
  // serviceLocator.registerLazySingleton<IAuthRepo>(
  //   () => AuthRepoImpl(
  //     remoteDataSource: serviceLocator(),
  //     localDataSource: serviceLocator(),
  //   ),
  // );

  // // Use Cases
  // serviceLocator.registerLazySingleton(
  //   () => LoginUseCase(authRepository: serviceLocator()),
  // );
  // serviceLocator.registerLazySingleton(
  //   () => SignUpUseCase(authRepository: serviceLocator()),
  // );
  // serviceLocator.registerLazySingleton(
  //   () => LogoutUseCase(authRepository: serviceLocator()),
  // );
  // serviceLocator.registerLazySingleton(
  //   () => GetLoggedInUserUseCase(authRepository: serviceLocator()),
  // );

  // // Bloc
  // serviceLocator.registerFactory(
  //   () => AuthBloc(
  //     loginUseCase: serviceLocator(),
  //     signUpUseCase: serviceLocator(),
  //     logoutUseCase: serviceLocator(),
  //     getLoggedInUserUseCase: serviceLocator(),
  //   ),
  // );
}

void _initTasks() {}

void _initProjects() {
  serviceLocator.registerLazySingleton(DatabaseHelper.new);
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
}
