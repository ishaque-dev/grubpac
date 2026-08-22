import 'package:equatable/equatable.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/utils/parsing_santizer.dart';
import 'package:grubpac/features/auth/domain/entities/token_response_entity.dart';

class TokenResponseModel extends Equatable {
  final String accessToken;
  final String refreshToken;
  final int accessTokenExpiresInSeconds;
  final int refreshTokenExpiresInSeconds;

  const TokenResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresInSeconds,
    required this.refreshTokenExpiresInSeconds,
  });

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) {
    return TokenResponseModel(
      accessToken: sanitizeWithType<String>(json[AppJsonKeys.accessToken]),
      refreshToken: sanitizeWithType<String>(json[AppJsonKeys.refreshToken]),
      accessTokenExpiresInSeconds: sanitizeWithType<int>(
        json[AppJsonKeys.accessTokenExpiresInSeconds],
      ),
      refreshTokenExpiresInSeconds: sanitizeWithType<int>(
        json[AppJsonKeys.refreshTokenExpiresInSeconds],
      ),
    );
  }

  factory TokenResponseModel.fromEntity(TokenResponseEntity entity) {
    return TokenResponseModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      accessTokenExpiresInSeconds: entity.accessTokenExpiresInSeconds,
      refreshTokenExpiresInSeconds: entity.refreshTokenExpiresInSeconds,
    );
  }

  TokenResponseEntity toEntity() {
    return TokenResponseEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessTokenExpiresInSeconds: accessTokenExpiresInSeconds,
      refreshTokenExpiresInSeconds: refreshTokenExpiresInSeconds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppJsonKeys.accessToken: accessToken,
      AppJsonKeys.refreshToken: refreshToken,
      AppJsonKeys.accessTokenExpiresInSeconds: accessTokenExpiresInSeconds,
      AppJsonKeys.refreshTokenExpiresInSeconds: refreshTokenExpiresInSeconds,
    };
  }

  TokenResponseModel copyWith({
    String? accessToken,
    String? refreshToken,
    int? accessTokenExpiresInSeconds,
    int? refreshTokenExpiresInSeconds,
  }) {
    return TokenResponseModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      accessTokenExpiresInSeconds:
          accessTokenExpiresInSeconds ?? this.accessTokenExpiresInSeconds,
      refreshTokenExpiresInSeconds:
          refreshTokenExpiresInSeconds ?? this.refreshTokenExpiresInSeconds,
    );
  }

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    accessTokenExpiresInSeconds,
    refreshTokenExpiresInSeconds,
  ];
}
