import 'package:get_it/get_it.dart';
import 'package:grubpac/features/projects/data/data_sources/i_projects_remote_ds.dart';
import 'package:grubpac/features/projects/data/impl/projects_remote_ds_impl.dart';
import 'package:grubpac/features/projects/data/impl/projects_repo_impl.dart';
import 'package:grubpac/features/projects/domain/repo/i_projects_repo.dart';

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
  serviceLocator.registerLazySingleton<IProjectsRemoteDs>(
    ProjectsRemoteDsImpl.new,
  );
  serviceLocator.registerLazySingleton<IProjectsRepo>(
    () => ProjectsRepoImpl(remoteDs: serviceLocator()),
  );
}
