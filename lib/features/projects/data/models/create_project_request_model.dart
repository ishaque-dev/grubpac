import 'package:equatable/equatable.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/features/projects/domain/entities/create_project_request_entity.dart';

class CreateProjectRequestModel extends Equatable {
  final String name;
  final String description;

  const CreateProjectRequestModel({
    required this.name,
    required this.description,
  });

  factory CreateProjectRequestModel.fromEntity(
    CreateProjectRequestEntity entity,
  ) {
    return CreateProjectRequestModel(
      name: entity.name,
      description: entity.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {AppJsonKeys.name: name, AppJsonKeys.description: description};
  }

  @override
  List<Object?> get props => [name, description];
}
