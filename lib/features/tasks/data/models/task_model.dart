import 'package:equatable/equatable.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/core/utils/parsing_santizer.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';

class TaskModel extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final String? assigneeId;
  final DateTime dueDate;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.assigneeId,
    required this.dueDate,
    required this.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: sanitizeWithType<String>(json[AppJsonKeys.id]),
      projectId: sanitizeWithType<String>(json[AppJsonKeys.projectId]),
      title: sanitizeWithType<String>(json[AppJsonKeys.title]),
      description: sanitizeWithType<String>(json[AppJsonKeys.description]),
      status: _statusFromJson(json[AppJsonKeys.status]),
      priority: _priorityFromJson(json[AppJsonKeys.priority]),
      assigneeId: _nullableString(json[AppJsonKeys.assigneeId]),
      dueDate: sanitizeWithType<DateTime>(json[AppJsonKeys.dueDate]),
      createdAt: sanitizeWithType<DateTime>(json[AppJsonKeys.createdAt]),
    );
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id ?? 'task_${DateTime.now().microsecondsSinceEpoch}',
      projectId: entity.projectId,
      title: entity.title,
      description: entity.description,
      status: entity.status,
      priority: entity.priority,
      assigneeId: entity.assigneeId,
      dueDate: entity.dueDate,
      createdAt: entity.createdAt ?? DateTime.now(),
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      projectId: projectId,
      title: title,
      description: description,
      status: status,
      priority: priority,
      assigneeId: assigneeId,
      dueDate: dueDate,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppJsonKeys.id: id,
      AppJsonKeys.projectId: projectId,
      AppJsonKeys.title: title,
      AppJsonKeys.description: description,
      AppJsonKeys.status: _statusToJson(status),
      AppJsonKeys.priority: _priorityToJson(priority),
      AppJsonKeys.assigneeId: assigneeId,
      AppJsonKeys.dueDate: dueDate.toIso8601String(),
      AppJsonKeys.createdAt: createdAt.toIso8601String(),
    };
  }

  TaskModel copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    String? assigneeId,
    DateTime? dueDate,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assigneeId: assigneeId ?? this.assigneeId,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    projectId,
    title,
    description,
    status,
    priority,
    assigneeId,
    dueDate,
    createdAt,
  ];
}

TaskStatus _statusFromJson(dynamic value) {
  return switch (sanitizeWithType<String>(value)) {
    'in_progress' => TaskStatus.inProgress,
    'review' => TaskStatus.review,
    'done' => TaskStatus.done,
    _ => TaskStatus.todo,
  };
}

String _statusToJson(TaskStatus status) {
  return switch (status) {
    TaskStatus.inProgress => 'in_progress',
    TaskStatus.review => 'review',
    TaskStatus.done => 'done',
    TaskStatus.todo => 'todo',
  };
}

TaskPriority _priorityFromJson(dynamic value) {
  return switch (sanitizeWithType<String>(value)) {
    'urgent' => TaskPriority.urgent,
    'high' => TaskPriority.high,
    'medium' => TaskPriority.medium,
    _ => TaskPriority.low,
  };
}

String _priorityToJson(TaskPriority priority) => priority.name;

String? _nullableString(dynamic value) {
  final result = sanitizeWithType<String>(value);
  return result.isEmpty ? null : result;
}
