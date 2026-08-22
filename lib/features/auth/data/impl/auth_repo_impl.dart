import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/error/common_failures.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/features/auth/data/data_sources/i_auth_local_ds.dart';
import 'package:grubpac/features/auth/data/data_sources/i_auth_remote_ds.dart';
import 'package:grubpac/features/auth/data/models/auth_request_model.dart';
import 'package:grubpac/features/auth/domain/entities/auth_request_entity.dart';
import 'package:grubpac/features/auth/domain/repo/i_auth_repo.dart';

class AuthRepoImpl implements IAuthRepo {
  AuthRepoImpl({required this._localDs, required this._remoteDs});

  final IAuthLocalDs _localDs;
  final IAuthRemoteDs _remoteDs;

  @override
  Future<Either<Failure, UserSessionEntity?>> getSavedSession() async {
    try {
      final session = await _localDs.getSession();

      return right(session?.toEntity());
    } catch (e) {
      return left(DefaultFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserSessionEntity>> login({
    required AuthRequestEntity request,
  }) async {
    try {
      final requestModel = AuthRequestModel.fromEntity(request);

      final session = await _remoteDs.login(request: requestModel);

      await _localDs.saveSession(session: session);

      return right(session.toEntity());
    } catch (e) {
      return left(DefaultFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDs.clearSession();

      return right(null);
    } catch (e) {
      return left(DefaultFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserSessionEntity>> refreshSession() async {
    try {
      final currentSession = await _localDs.getSession();

      if (currentSession == null) {
        return left(
          DefaultFailure(message: AppInternalStrings.noActiveSession),
        );
      }

      final tokenResponse = await _remoteDs.refreshToken(
        refreshToken: currentSession.refreshToken,
      );

      final now = DateTime.now();

      final updatedSession = currentSession.copyWith(
        accessToken: tokenResponse.accessToken,
        refreshToken: tokenResponse.refreshToken,
        accessTokenExpiresAt: now.add(
          Duration(seconds: tokenResponse.accessTokenExpiresInSeconds),
        ),
        refreshTokenExpiresAt: now.add(
          Duration(seconds: tokenResponse.refreshTokenExpiresInSeconds),
        ),
      );

      await _localDs.saveSession(session: updatedSession);

      return right(updatedSession.toEntity());
    } catch (e) {
      return left(DefaultFailure(message: e.toString()));
    }
  }
}
