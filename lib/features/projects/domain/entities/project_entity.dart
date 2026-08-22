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
}
