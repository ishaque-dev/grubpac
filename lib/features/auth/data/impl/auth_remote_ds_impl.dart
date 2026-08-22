import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/core/utils/parsing_santizer.dart';
import 'package:grubpac/features/auth/data/data_sources/i_auth_remote_ds.dart';
import 'package:grubpac/features/auth/data/models/auth_request_model.dart';
import 'package:grubpac/features/auth/data/models/token_response_model.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';

class AuthRemoteDsImpl implements IAuthRemoteDs {
  static const Duration _mockDelay = Duration(seconds: 1);

  @override
  Future<UserSessionModel> login({required AuthRequestModel request}) async {
    await Future.delayed(_mockDelay);

    final jsonString = await rootBundle.loadString(
      AppInternalStrings.mockDataAsset,
    );

    final data = _decodeJsonMap(jsonString);

    final authMock = _mapValue(data[AppJsonKeys.authMock]);

    final credentials = _listValue(authMock[AppJsonKeys.testCredentials]);

    final matchingCredential = credentials
        .map(_mapValue)
        .firstWhere(
          (credential) =>
              sanitizeWithType<String>(credential[AppJsonKeys.email]) ==
                  request.email &&
              sanitizeWithType<String>(credential[AppJsonKeys.password]) ==
                  request.password,
        );

    final users = _listValue(data[AppJsonKeys.users]);

    final matchingUser = users
        .map(_mapValue)
        .firstWhere(
          (user) =>
              sanitizeWithType<String>(user[AppJsonKeys.email]) ==
              sanitizeWithType<String>(matchingCredential[AppJsonKeys.email]),
        );

    final tokenResponse = _mapValue(authMock[AppJsonKeys.mockLoginResponse]);

    final now = DateTime.now();

    return UserSessionModel(
      userId: sanitizeWithType<String>(matchingUser[AppJsonKeys.id]),
      organizationId: sanitizeWithType<String>(
        matchingCredential[AppJsonKeys.organizationId],
      ),
      role: UserRole.values.firstWhere(
        (value) =>
            value.name ==
            sanitizeWithType<String>(matchingCredential[AppJsonKeys.role]),
        orElse: () => UserRole.values.first,
      ),
      accessToken: sanitizeWithType<String>(
        tokenResponse[AppJsonKeys.accessToken],
      ),
      refreshToken: sanitizeWithType<String>(
        tokenResponse[AppJsonKeys.refreshToken],
      ),
      accessTokenExpiresAt: now.add(
        Duration(
          seconds: sanitizeWithType<int>(
            tokenResponse[AppJsonKeys.accessTokenExpiresInSeconds],
          ),
        ),
      ),
      refreshTokenExpiresAt: now.add(
        Duration(
          seconds: sanitizeWithType<int>(
            tokenResponse[AppJsonKeys.refreshTokenExpiresInSeconds],
          ),
        ),
      ),
    );
  }

  @override
  Future<TokenResponseModel> refreshToken({
    required String refreshToken,
  }) async {
    await Future.delayed(_mockDelay);

    final jsonString = await rootBundle.loadString(
      AppInternalStrings.mockDataAsset,
    );

    final data = _decodeJsonMap(jsonString);

    final authMock = _mapValue(data[AppJsonKeys.authMock]);

    final response = _mapValue(authMock[AppJsonKeys.mockLoginResponse]);

    return TokenResponseModel(
      accessToken: sanitizeWithType<String>(response[AppJsonKeys.accessToken]),
      refreshToken: sanitizeWithType<String>(
        response[AppJsonKeys.refreshToken],
      ),
      accessTokenExpiresInSeconds: sanitizeWithType<int>(
        response[AppJsonKeys.accessTokenExpiresInSeconds],
      ),
      refreshTokenExpiresInSeconds: sanitizeWithType<int>(
        response[AppJsonKeys.refreshTokenExpiresInSeconds],
      ),
    );
  }

  Map<String, dynamic> _decodeJsonMap(String value) {
    try {
      return sanitizeWithType<Map<String, dynamic>>(
        jsonDecode(value),
        defaultValue: <String, dynamic>{},
      );
    } on FormatException {
      return <String, dynamic>{};
    }
  }

  Map<String, dynamic> _mapValue(dynamic value) {
    return sanitizeWithType<Map<String, dynamic>>(
      value,
      defaultValue: <String, dynamic>{},
    );
  }

  List<dynamic> _listValue(dynamic value) {
    return sanitizeWithType<List<dynamic>>(value, defaultValue: <dynamic>[]);
  }
}
