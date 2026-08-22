import 'package:grubpac/core/shared/enums.dart';

class TaskEntity {
  final String? id;

  final String projectId;

  final String title;

  final String description;

  final TaskStatus status;

  final TaskPriority priority;

  final String? assigneeId;

  final DateTime dueDate;

  final DateTime? createdAt;

  const TaskEntity({
    this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.assigneeId,
    required this.dueDate,
    this.createdAt,
  });

  TaskEntity copyWith({
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
    return TaskEntity(
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
}
