import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/utils/mock_data.dart';
import 'package:grubpac/core/utils/parsing_santizer.dart';
import 'package:grubpac/features/auth/data/data_sources/i_auth_local_ds.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';

class AuthLocalDsImpl implements IAuthLocalDs {
  AuthLocalDsImpl({required this._secureStorage});

  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> saveSession({required UserSessionModel session}) async {
    final sessionJson = jsonEncode(session.toJson());

    await _secureStorage.write(
      key: AppInternalStrings.sessionKey,
      value: sessionJson,
    );
  }

  @override
  Future<UserSessionModel?> getSession() async {
    final sessionJson = await _secureStorage.read(
      key: AppInternalStrings.sessionKey,
    );

    if (sessionJson == null) {
      return null;
    }

    final sessionMap = _decodeJsonMap(sessionJson);
    final session = UserSessionModel.fromJson(sessionMap);

    // Fetch latest user details from mock data source
    try {
      final data = await MockApiResponse.load();
      final users = sanitizeWithType<List<dynamic>>(
        data[AppJsonKeys.users],
        defaultValue: <dynamic>[],
      );

      final userData = users.firstWhere(
        (user) =>
            sanitizeWithType<String>(user[AppJsonKeys.id]) == session.userId,
        orElse: () => null,
      );

      if (userData != null) {
        return session.copyWith(
          userName: sanitizeWithType<String>(userData[AppJsonKeys.name]),
          avatarUrl: sanitizeWithType<String>(userData['avatar_url']),
        );
      }
    } catch (_) {
      // Fallback to what was saved if mock data lookup fails
    }

    return session;
  }

  @override
  Future<void> clearSession() async {
    await _secureStorage.delete(key: AppInternalStrings.sessionKey);
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
}
