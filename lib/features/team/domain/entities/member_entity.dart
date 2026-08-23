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
}
