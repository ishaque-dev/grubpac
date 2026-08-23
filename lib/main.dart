import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac/core/di/di.dart';
import 'package:grubpac/core/router/app_router.dart';
import 'package:grubpac/core/theme/app_theme.dart';
import 'package:grubpac/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:grubpac/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:grubpac/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:grubpac/features/team/presentation/bloc/team_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = serviceLocator<AuthBloc>()..add(AuthSessionRequested());
    _appRouter = AppRouter(authBloc: _authBloc);
  }

  @override
  void dispose() {
    _appRouter.dispose();
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: _authBloc),
            BlocProvider(create: (context) => serviceLocator<ProjectsBloc>()),
            BlocProvider(create: (context) => serviceLocator<TaskBloc>()),
            BlocProvider(create: (context) => serviceLocator<TeamBloc>()),
          ],
          child: MaterialApp.router(
            title: 'TaskFlow',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
            routerConfig: _appRouter.router,
          ),
        );
      },
    );
  }
}
