import 'package:equatable/equatable.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/core/utils/parsing_santizer.dart';

class UserSessionModel extends Equatable {
  final String userId;
  final String organizationId;
  final UserRole role;
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpiresAt;
  final DateTime refreshTokenExpiresAt;

  const UserSessionModel({
    required this.userId,
    required this.organizationId,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresAt,
    required this.refreshTokenExpiresAt,
  });

  factory UserSessionModel.fromJson(Map<String, dynamic> json) {
    return UserSessionModel(
      userId: sanitizeWithType<String>(json[AppJsonKeys.userId]),
      organizationId: sanitizeWithType<String>(
        json[AppJsonKeys.organizationId],
      ),
      role: UserRole.values.firstWhere(
        (value) =>
            value.name == sanitizeWithType<String>(json[AppJsonKeys.role]),
        orElse: () => UserRole.values.first,
      ),
      accessToken: sanitizeWithType<String>(json[AppJsonKeys.accessToken]),
      refreshToken: sanitizeWithType<String>(json[AppJsonKeys.refreshToken]),
      accessTokenExpiresAt: sanitizeWithType<DateTime>(
        json[AppJsonKeys.accessTokenExpiresAt],
      ),
      refreshTokenExpiresAt: sanitizeWithType<DateTime>(
        json[AppJsonKeys.refreshTokenExpiresAt],
      ),
    );
  }

  factory UserSessionModel.fromEntity(UserSessionEntity entity) {
    return UserSessionModel(
      userId: entity.userId,
      organizationId: entity.organizationId,
      role: entity.role,
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      accessTokenExpiresAt: entity.accessTokenExpiresAt,
      refreshTokenExpiresAt: entity.refreshTokenExpiresAt,
    );
  }

  UserSessionEntity toEntity() {
    return UserSessionEntity(
      userId: userId,
      organizationId: organizationId,
      role: role,
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessTokenExpiresAt: accessTokenExpiresAt,
      refreshTokenExpiresAt: refreshTokenExpiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppJsonKeys.userId: userId,
      AppJsonKeys.organizationId: organizationId,
      AppJsonKeys.role: role.name,
      AppJsonKeys.accessToken: accessToken,
      AppJsonKeys.refreshToken: refreshToken,
      AppJsonKeys.accessTokenExpiresAt: accessTokenExpiresAt.toIso8601String(),
      AppJsonKeys.refreshTokenExpiresAt: refreshTokenExpiresAt
          .toIso8601String(),
    };
  }

  UserSessionModel copyWith({
    String? userId,
    String? organizationId,
    UserRole? role,
    String? accessToken,
    String? refreshToken,
    DateTime? accessTokenExpiresAt,
    DateTime? refreshTokenExpiresAt,
  }) {
    return UserSessionModel(
      userId: userId ?? this.userId,
      organizationId: organizationId ?? this.organizationId,
      role: role ?? this.role,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      accessTokenExpiresAt: accessTokenExpiresAt ?? this.accessTokenExpiresAt,
      refreshTokenExpiresAt:
          refreshTokenExpiresAt ?? this.refreshTokenExpiresAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    organizationId,
    role,
    accessToken,
    refreshToken,
    accessTokenExpiresAt,
    refreshTokenExpiresAt,
  ];
}
