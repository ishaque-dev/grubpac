import 'package:equatable/equatable.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/utils/parsing_santizer.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';

class ProjectModel extends Equatable {
  final String id;
  final String organizationId;
  final String name;
  final String description;
  final int taskCount;
  final String status;
  final DateTime createdAt;

  const ProjectModel({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.description,
    required this.taskCount,
    required this.status,
    required this.createdAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: sanitizeWithType<String>(json[AppJsonKeys.id]),
      organizationId: sanitizeWithType<String>(json[AppJsonKeys.organizationId]),
      name: sanitizeWithType<String>(json[AppJsonKeys.name]),
      description: sanitizeWithType<String>(json[AppJsonKeys.description]),
      taskCount: sanitizeWithType<int>(json[AppJsonKeys.taskCount]),
      status: sanitizeWithType<String>(json[AppJsonKeys.status]),
      createdAt: sanitizeWithType<DateTime>(json[AppJsonKeys.createdAt]),
    );
  }

  factory ProjectModel.fromEntity(ProjectEntity entity) {
    return ProjectModel(
      id: entity.id,
      organizationId: entity.organizationId,
      name: entity.name,
      description: entity.description,
      taskCount: entity.taskCount,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }

  ProjectEntity toEntity() {
    return ProjectEntity(
      id: id,
      organizationId: organizationId,
      name: name,
      description: description,
      taskCount: taskCount,
      status: status,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppJsonKeys.id: id,
      AppJsonKeys.organizationId: organizationId,
      AppJsonKeys.name: name,
      AppJsonKeys.description: description,
      AppJsonKeys.taskCount: taskCount,
      AppJsonKeys.status: status,
      AppJsonKeys.createdAt: createdAt.toIso8601String(),
    };
  }

  ProjectModel copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? description,
    int? taskCount,
    String? status,
    DateTime? createdAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      description: description ?? this.description,
      taskCount: taskCount ?? this.taskCount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    organizationId,
    name,
    description,
    taskCount,
    status,
    createdAt,
  ];
}