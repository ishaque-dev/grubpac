import 'package:grubpac/features/auth/data/models/user_session_model.dart';

abstract interface class IAuthLocalDs {
  Future<void> saveSession({required UserSessionModel session});

  Future<UserSessionModel?> getSession();

  Future<void> clearSession();
}
