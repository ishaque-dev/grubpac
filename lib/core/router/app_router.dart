import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grubpac/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:grubpac/features/auth/presentation/pages/login_page.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';
import 'package:grubpac/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:grubpac/features/projects/presentation/pages/projects_page.dart';
import 'package:grubpac/features/tasks/presentation/pages/tasks_page.dart';

class AppRouter {
  AppRouter({required AuthBloc authBloc})
    : _authRefresh = _AuthRouterRefresh(authBloc) {
    router = GoRouter(
      initialLocation: '/projects',
      refreshListenable: _authRefresh,
      redirect: (context, state) {
        final authState = authBloc.state;
        final isLoading = authState is AuthInitial || authState is AuthLoading;
        final isAuthenticated = authState is AuthAuthenticated;
        final isLogin = state.matchedLocation == '/login';

        if (isLoading) return null;
        if (!isAuthenticated && !isLogin) return '/login';
        if (isAuthenticated && isLogin) return '/projects';
        return null;
      },
      routes: [
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/projects',
          builder: (context, state) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is AuthInitial || authState is AuthLoading) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (authState is! AuthAuthenticated) {
                  return const LoginPage();
                }
                return ProjectsPage(session: authState.session);
              },
            );
          },
          routes: [
            GoRoute(
              path: ':projectId/tasks',
              builder: (context, state) {
                final authState = authBloc.state;
                final project = state.extra is ProjectEntity
                    ? state.extra! as ProjectEntity
                    : _findProject(context, state.pathParameters['projectId']);
                if (authState is! AuthAuthenticated || project == null) {
                  return const Scaffold(
                    body: Center(child: Text('Project not found')),
                  );
                }
                return TasksPage(project: project, session: authState.session);
              },
            ),
          ],
        ),
      ],
    );
  }

  final _AuthRouterRefresh _authRefresh;
  late final GoRouter router;

  void dispose() {
    _authRefresh.dispose();
    router.dispose();
  }

  static ProjectEntity? _findProject(BuildContext context, String? id) {
    if (id == null) return null;
    final state = context.read<ProjectsBloc>().state;
    if (state is ProjectsLoaded) {
      for (final project in state.projects) {
        if (project.id == id) return project;
      }
    }
    return null;
  }
}

class _AuthRouterRefresh extends ChangeNotifier {
  _AuthRouterRefresh(AuthBloc bloc) {
    _subscription = bloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
