import 'package:get_it/get_it.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Auth Feature
  _initAuth();

  // Tasks Feature
  _initTasks();
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
