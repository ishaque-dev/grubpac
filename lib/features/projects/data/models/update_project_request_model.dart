import 'package:equatable/equatable.dart';
import 'package:grubpac/features/projects/domain/entities/update_project_request_entity.dart';

class UpdateProjectRequestModel extends Equatable {
  final String projectId;
  final String? name;
  final String? description;
  final String? status;

  const UpdateProjectRequestModel({
    required this.projectId,
    this.name,
    this.description,
    this.status,
  });

  factory UpdateProjectRequestModel.fromEntity(
    UpdateProjectRequestEntity entity,
  ) {
    return UpdateProjectRequestModel(
      projectId: entity.projectId,
      name: entity.name,
      description: entity.description,
      status: entity.status,
    );
  }

  @override
  List<Object?> get props => [projectId, name, description, status];
}
