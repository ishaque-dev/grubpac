import 'package:grubpac/core/shared/enums.dart';

class UserSessionEntity {
  final String userId;
  final String organizationId;
  final UserRole role;

  final String accessToken;
  final String refreshToken;

  final DateTime accessTokenExpiresAt;
  final DateTime refreshTokenExpiresAt;

  const UserSessionEntity({
    required this.userId,
    required this.organizationId,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresAt,
    required this.refreshTokenExpiresAt,
  });

  bool get isAccessTokenExpired => DateTime.now().isAfter(accessTokenExpiresAt);

  bool get isRefreshTokenExpired =>
      DateTime.now().isAfter(refreshTokenExpiresAt);
}
