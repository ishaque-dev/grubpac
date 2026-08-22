class ProjectEntity {
  final String id;
  final String organizationId;
  final String name;
  final String description;
  final int taskCount;
  final String status;
  final DateTime createdAt;

  const ProjectEntity({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.description,
    required this.taskCount,
    required this.status,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          organizationId == other.organizationId &&
          name == other.name &&
          description == other.description &&
          taskCount == other.taskCount &&
          status == other.status &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      organizationId.hashCode ^
      name.hashCode ^
      description.hashCode ^
      taskCount.hashCode ^
      status.hashCode ^
      createdAt.hashCode;
}
