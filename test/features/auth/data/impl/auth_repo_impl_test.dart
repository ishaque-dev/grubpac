import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/error/common_failures.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/features/auth/data/data_sources/i_auth_local_ds.dart';
import 'package:grubpac/features/auth/data/data_sources/i_auth_remote_ds.dart';
import 'package:grubpac/features/auth/data/impl/auth_repo_impl.dart';
import 'package:grubpac/features/auth/data/models/auth_request_model.dart';
import 'package:grubpac/features/auth/data/models/token_response_model.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/auth/domain/entities/auth_request_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDs extends Mock implements IAuthLocalDs {}

class MockAuthRemoteDs extends Mock implements IAuthRemoteDs {}

void main() {
  late AuthRepoImpl authRepo;
  late MockAuthLocalDs mockLocalDs;
  late MockAuthRemoteDs mockRemoteDs;

  final tNow = DateTime(2024, 1, 1);
  setUp(() {
    mockLocalDs = MockAuthLocalDs();
    mockRemoteDs = MockAuthRemoteDs();
    authRepo = AuthRepoImpl(localDs: mockLocalDs, remoteDs: mockRemoteDs);
  });

  final tUserSessionModel = UserSessionModel(
    userId: '1',
    organizationId: '1',
    role: UserRole.orgAdmin,
    accessToken: 'access',
    refreshToken: 'refresh',
    accessTokenExpiresAt: tNow.add(const Duration(hours: 1)),
    refreshTokenExpiresAt: tNow.add(const Duration(days: 1)),
  );

  final tUserSessionEntity = tUserSessionModel.toEntity();

  final tAuthRequestEntity = const AuthRequestEntity(
    email: 'test@test.com',
    password: 'password',
  );
  final tAuthRequestModel = AuthRequestModel.fromEntity(tAuthRequestEntity);

  final tTokenResponseModel = const TokenResponseModel(
    accessToken: 'new_access',
    refreshToken: 'new_refresh',
    accessTokenExpiresInSeconds: 3600,
    refreshTokenExpiresInSeconds: 86400,
  );

  group('getSavedSession', () {
    test('should return session from local data source when it exists', () async {
      // arrange
      when(() => mockLocalDs.getSession()).thenAnswer((_) async => tUserSessionModel);
      // act
      final result = await authRepo.getSavedSession();
      // assert
      expect(result, equals(Right<Failure, dynamic>(tUserSessionEntity)));
      verify(() => mockLocalDs.getSession()).called(1);
    });

    test('should return null when no session in local data source', () async {
      // arrange
      when(() => mockLocalDs.getSession()).thenAnswer((_) async => null);
      // act
      final result = await authRepo.getSavedSession();
      // assert
      expect(result, equals(Right<Failure, dynamic>(null)));
      verify(() => mockLocalDs.getSession()).called(1);
    });

    test('should return failure when local data source throws error', () async {
      // arrange
      when(() => mockLocalDs.getSession()).thenThrow(Exception('error'));
      // act
      final result = await authRepo.getSavedSession();
      // assert
      expect(result.isLeft(), true);
      verify(() => mockLocalDs.getSession()).called(1);
    });
  });

  group('login', () {
    setUpAll(() {
      registerFallbackValue(tAuthRequestModel);
      registerFallbackValue(tUserSessionModel);
    });

    test('should call remote login and save session locally on success', () async {
      // arrange
      when(
        () => mockRemoteDs.login(request: any(named: 'request')),
      ).thenAnswer((_) async => tUserSessionModel);
      when(
        () => mockLocalDs.saveSession(session: any(named: 'session')),
      ).thenAnswer((_) async => {});

      // act
      final result = await authRepo.login(request: tAuthRequestEntity);

      // assert
      expect(result, equals(Right<Failure, dynamic>(tUserSessionEntity)));
      verify(() => mockRemoteDs.login(request: any(named: 'request'))).called(1);
      verify(() => mockLocalDs.saveSession(session: tUserSessionModel)).called(1);
    });

    test('should return failure when remote login fails', () async {
      // arrange
      when(
        () => mockRemoteDs.login(request: any(named: 'request')),
      ).thenThrow(Exception('login failed'));

      // act
      final result = await authRepo.login(request: tAuthRequestEntity);

      // assert
      expect(result.isLeft(), true);
      verify(() => mockRemoteDs.login(request: any(named: 'request'))).called(1);
      verifyNever(() => mockLocalDs.saveSession(session: any(named: 'session')));
    });
  });

  group('logout', () {
    test('should clear local session', () async {
      // arrange
      when(() => mockLocalDs.clearSession()).thenAnswer((_) async => {});

      // act
      final result = await authRepo.logout();

      // assert
      expect(result, equals(Right<Failure, dynamic>(null)));
      verify(() => mockLocalDs.clearSession()).called(1);
    });

    test('should return failure when clearSession fails', () async {
      // arrange
      when(() => mockLocalDs.clearSession()).thenThrow(Exception('logout failed'));

      // act
      final result = await authRepo.logout();

      // assert
      expect(result.isLeft(), true);
      verify(() => mockLocalDs.clearSession()).called(1);
    });
  });

  group('refreshSession', () {
    test('should return failure if no session exists locally', () async {
      // arrange
      when(() => mockLocalDs.getSession()).thenAnswer((_) async => null);

      // act
      final result = await authRepo.refreshSession();

      // assert
      expect(
        result,
        equals(Left<Failure, UserSessionEntity>(DefaultFailure(message: AppInternalStrings.noActiveSession))),
      );
      verify(() => mockLocalDs.getSession()).called(1);
      verifyNever(
        () => mockRemoteDs.refreshToken(refreshToken: any(named: 'refreshToken')),
      );
    });

    test('should refresh token and save updated session locally', () async {
      // arrange
      when(() => mockLocalDs.getSession()).thenAnswer((_) async => tUserSessionModel);
      when(
        () => mockRemoteDs.refreshToken(refreshToken: any(named: 'refreshToken')),
      ).thenAnswer((_) async => tTokenResponseModel);
      when(
        () => mockLocalDs.saveSession(session: any(named: 'session')),
      ).thenAnswer((_) async => {});

      // act
      final result = await authRepo.refreshSession();

      // assert
      expect(result.isRight(), true);
      verify(() => mockLocalDs.getSession()).called(1);
      verify(
        () => mockRemoteDs.refreshToken(refreshToken: tUserSessionModel.refreshToken),
      ).called(1);
      verify(() => mockLocalDs.saveSession(session: any(named: 'session'))).called(1);
    });

    test('should return failure if refresh fails', () async {
      // arrange
      when(() => mockLocalDs.getSession()).thenAnswer((_) async => tUserSessionModel);
      when(
        () => mockRemoteDs.refreshToken(refreshToken: any(named: 'refreshToken')),
      ).thenThrow(Exception('refresh failed'));

      // act
      final result = await authRepo.refreshSession();

      // assert
      expect(result.isLeft(), true);
      verify(() => mockLocalDs.getSession()).called(1);
      verify(
        () => mockRemoteDs.refreshToken(refreshToken: tUserSessionModel.refreshToken),
      ).called(1);
      verifyNever(() => mockLocalDs.saveSession(session: any(named: 'session')));
    });
  });
}
