import 'package:grubpac/core/shared/enums.dart';

class UserSessionEntity {
  final String userId;
  final String? userName;
  final String? avatarUrl;
  final String organizationId;
  final UserRole role;

  final String accessToken;
  final String refreshToken;

  final DateTime accessTokenExpiresAt;
  final DateTime refreshTokenExpiresAt;

  const UserSessionEntity({
    required this.userId,
    this.userName,
    this.avatarUrl,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSessionEntity &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          userName == other.userName &&
          avatarUrl == other.avatarUrl &&
          organizationId == other.organizationId &&
          role == other.role &&
          accessToken == other.accessToken &&
          refreshToken == other.refreshToken &&
          accessTokenExpiresAt == other.accessTokenExpiresAt &&
          refreshTokenExpiresAt == other.refreshTokenExpiresAt;

  @override
  int get hashCode =>
      userId.hashCode ^
      userName.hashCode ^
      avatarUrl.hashCode ^
      organizationId.hashCode ^
      role.hashCode ^
      accessToken.hashCode ^
      refreshToken.hashCode ^
      accessTokenExpiresAt.hashCode ^
      refreshTokenExpiresAt.hashCode;
}
