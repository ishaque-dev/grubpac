import 'package:equatable/equatable.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/utils/parsing_santizer.dart';
import 'package:grubpac/features/auth/domain/entities/auth_request_entity.dart';

class AuthRequestModel extends Equatable {
  final String email;
  final String password;

  const AuthRequestModel({required this.email, required this.password});

  factory AuthRequestModel.fromJson(Map<String, dynamic> json) {
    return AuthRequestModel(
      email: sanitizeWithType<String>(json[AppJsonKeys.email]),
      password: sanitizeWithType<String>(json[AppJsonKeys.password]),
    );
  }

  factory AuthRequestModel.fromEntity(AuthRequestEntity entity) {
    return AuthRequestModel(email: entity.email, password: entity.password);
  }

  AuthRequestEntity toEntity() {
    return AuthRequestEntity(email: email, password: password);
  }

  Map<String, dynamic> toJson() {
    return {AppJsonKeys.email: email, AppJsonKeys.password: password};
  }

  AuthRequestModel copyWith({String? email, String? password}) {
    return AuthRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [email, password];
}
