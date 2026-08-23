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
    bool clearAssignee = false,
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
      assigneeId: clearAssignee ? null : assigneeId ?? this.assigneeId,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          projectId == other.projectId &&
          title == other.title &&
          description == other.description &&
          status == other.status &&
          priority == other.priority &&
          assigneeId == other.assigneeId &&
          dueDate == other.dueDate &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      projectId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      status.hashCode ^
      priority.hashCode ^
      assigneeId.hashCode ^
      dueDate.hashCode ^
      createdAt.hashCode;
}
