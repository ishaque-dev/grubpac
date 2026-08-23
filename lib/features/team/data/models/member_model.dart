import 'package:equatable/equatable.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/utils/parsing_santizer.dart';
import 'package:grubpac/features/team/domain/entities/member_entity.dart';

class MemberModel extends Equatable {
  const MemberModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.role,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role;

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    final avatar = sanitizeWithType<String>(json[AppJsonKeys.avatarUrl]);
    return MemberModel(
      id: sanitizeWithType<String>(json[AppJsonKeys.id]),
      name: sanitizeWithType<String>(json[AppJsonKeys.name]),
      email: sanitizeWithType<String>(json[AppJsonKeys.email]),
      avatarUrl: avatar.isEmpty ? null : avatar,
      role: sanitizeWithType<String>(json[AppJsonKeys.role]),
    );
  }

  MemberEntity toEntity() => MemberEntity(
    id: id,
    name: name,
    email: email,
    avatarUrl: avatarUrl,
    role: role,
  );

  @override
  List<Object?> get props => [id, name, email, avatarUrl, role];
}
