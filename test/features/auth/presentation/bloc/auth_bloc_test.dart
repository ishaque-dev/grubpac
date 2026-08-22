import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/common_failures.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/auth/domain/entities/auth_request_entity.dart';
import 'package:grubpac/features/auth/domain/use_cases/get_saved_session_use_case.dart';
import 'package:grubpac/features/auth/domain/use_cases/login_use_case.dart';
import 'package:grubpac/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:grubpac/features/auth/domain/use_cases/refresh_session_use_case.dart';
import 'package:grubpac/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetSavedSessionUseCase extends Mock implements GetSavedSessionUseCase {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockRefreshSessionUseCase extends Mock implements RefreshSessionUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockGetSavedSessionUseCase mockGetSavedSession;
  late MockLoginUseCase mockLogin;
  late MockLogoutUseCase mockLogout;
  late MockRefreshSessionUseCase mockRefreshSession;

  setUp(() {
    mockGetSavedSession = MockGetSavedSessionUseCase();
    mockLogin = MockLoginUseCase();
    mockLogout = MockLogoutUseCase();
    mockRefreshSession = MockRefreshSessionUseCase();

    authBloc = AuthBloc(
      getSavedSession: mockGetSavedSession,
      login: mockLogin,
      logout: mockLogout,
      refreshSession: mockRefreshSession,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  final tUserSession = UserSessionEntity(
    userId: '1',
    organizationId: '1',
    role: UserRole.orgAdmin,
    accessToken: 'access',
    refreshToken: 'refresh',
    accessTokenExpiresAt: DateTime.now().add(const Duration(hours: 1)),
    refreshTokenExpiresAt: DateTime.now().add(const Duration(days: 1)),
  );

  final tExpiredAccessTokenSession = UserSessionEntity(
    userId: '1',
    organizationId: '1',
    role: UserRole.orgAdmin,
    accessToken: 'access',
    refreshToken: 'refresh',
    accessTokenExpiresAt: DateTime.now().subtract(const Duration(hours: 1)),
    refreshTokenExpiresAt: DateTime.now().add(const Duration(days: 1)),
  );

  final tExpiredRefreshTokenSession = UserSessionEntity(
    userId: '1',
    organizationId: '1',
    role: UserRole.orgAdmin,
    accessToken: 'access',
    refreshToken: 'refresh',
    accessTokenExpiresAt: DateTime.now().subtract(const Duration(hours: 2)),
    refreshTokenExpiresAt: DateTime.now().subtract(const Duration(hours: 1)),
  );

  group('AuthSessionRequested', () {
    setUpAll(() {
      registerFallbackValue(NoParam());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when session is valid',
      build: () {
        when(
          () => mockGetSavedSession(parameters: any(named: 'parameters')),
        ).thenAnswer((_) async => right(tUserSession));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSessionRequested()),
      expect: () => [AuthLoading(), AuthAuthenticated(tUserSession)],
      verify: (_) {
        verify(
          () => mockGetSavedSession(parameters: any(named: 'parameters')),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when session is null',
      build: () {
        when(
          () => mockGetSavedSession(parameters: any(named: 'parameters')),
        ).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSessionRequested()),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when refresh token is expired',
      build: () {
        when(
          () => mockGetSavedSession(parameters: any(named: 'parameters')),
        ).thenAnswer((_) async => right(tExpiredRefreshTokenSession));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSessionRequested()),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] after refresh when access token is expired',
      build: () {
        when(
          () => mockGetSavedSession(parameters: any(named: 'parameters')),
        ).thenAnswer((_) async => right(tExpiredAccessTokenSession));
        when(
          () => mockRefreshSession(parameters: any(named: 'parameters')),
        ).thenAnswer((_) async => right(tUserSession));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSessionRequested()),
      expect: () => [AuthLoading(), AuthAuthenticated(tUserSession)],
      verify: (_) {
        verify(
          () => mockRefreshSession(parameters: any(named: 'parameters')),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when getSavedSession fails',
      build: () {
        when(
          () => mockGetSavedSession(parameters: any(named: 'parameters')),
        ).thenAnswer((_) async => left(DefaultFailure(message: 'error')));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSessionRequested()),
      expect: () => [AuthLoading(), const AuthFailure('error')],
    );
  });

  group('AuthLoginRequested', () {
    const tEmail = 'test@test.com';
    const tPassword = 'password';
    const tAuthRequest = AuthRequestEntity(email: tEmail, password: tPassword);

    setUpAll(() {
      registerFallbackValue(tAuthRequest);
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login is successful',
      build: () {
        when(
          () => mockLogin(parameters: any(named: 'parameters')),
        ).thenAnswer((_) async => right(tUserSession));
        return authBloc;
      },
      act:
          (bloc) =>
              bloc.add(const AuthLoginRequested(email: tEmail, password: tPassword)),
      expect: () => [AuthLoading(), AuthAuthenticated(tUserSession)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when login fails',
      build: () {
        when(
          () => mockLogin(parameters: any(named: 'parameters')),
        ).thenAnswer(
          (_) async => left(DefaultFailure(message: 'login failed')),
        );
        return authBloc;
      },
      act:
          (bloc) =>
              bloc.add(const AuthLoginRequested(email: tEmail, password: tPassword)),
      expect: () => [AuthLoading(), const AuthFailure('login failed')],
    );
  });

  group('AuthLogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when logout is successful',
      build: () {
        when(
          () => mockLogout(parameters: any(named: 'parameters')),
        ).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when logout fails',
      build: () {
        when(
          () => mockLogout(parameters: any(named: 'parameters')),
        ).thenAnswer(
          (_) async => left(DefaultFailure(message: 'logout failed')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      expect: () => [AuthLoading(), const AuthFailure('logout failed')],
    );
  });

  group('AuthRefreshRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when refresh is successful',
      build: () {
        when(
          () => mockRefreshSession(parameters: any(named: 'parameters')),
        ).thenAnswer((_) async => right(tUserSession));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthRefreshRequested()),
      expect: () => [AuthLoading(), AuthAuthenticated(tUserSession)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when refresh fails',
      build: () {
        when(
          () => mockRefreshSession(parameters: any(named: 'parameters')),
        ).thenAnswer(
          (_) async => left(DefaultFailure(message: 'refresh failed')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthRefreshRequested()),
      expect: () => [AuthLoading(), const AuthFailure('refresh failed')],
    );
  });
}
