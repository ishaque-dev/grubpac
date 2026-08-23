class MemberEntity {
  const MemberEntity({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          avatarUrl == other.avatarUrl &&
          role == other.role;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      avatarUrl.hashCode ^
      role.hashCode;
}
