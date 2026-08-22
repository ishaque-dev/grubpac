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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateProjectRequestEntity &&
          runtimeType == other.runtimeType &&
          projectId == other.projectId &&
          name == other.name &&
          description == other.description &&
          status == other.status;

  @override
  int get hashCode =>
      projectId.hashCode ^
      name.hashCode ^
      description.hashCode ^
      status.hashCode;
}
