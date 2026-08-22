class CreateProjectRequestEntity {
  final String name;
  final String description;

  const CreateProjectRequestEntity({
    required this.name,
    required this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateProjectRequestEntity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          description == other.description;

  @override
  int get hashCode => name.hashCode ^ description.hashCode;
}
