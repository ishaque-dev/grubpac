class UpdateProjectRequestEntity {
  final String projectId;
  final String? name;
  final String? description;
  final String? status;

  const UpdateProjectRequestEntity({
    required this.projectId,
    this.name,
    this.description,
    this.status,
  });
}
