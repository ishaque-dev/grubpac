import 'package:grubpac/core/shared/enums.dart';

class TaskFilterEntity {
  final TaskStatus? status;

  final TaskPriority? priority;

  final String? assigneeId;

  final DateTime? dueDateFrom;

  final DateTime? dueDateTo;

  const TaskFilterEntity({
    this.status,
    this.priority,
    this.assigneeId,
    this.dueDateFrom,
    this.dueDateTo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskFilterEntity &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          priority == other.priority &&
          assigneeId == other.assigneeId &&
          dueDateFrom == other.dueDateFrom &&
          dueDateTo == other.dueDateTo;

  @override
  int get hashCode =>
      status.hashCode ^
      priority.hashCode ^
      assigneeId.hashCode ^
      dueDateFrom.hashCode ^
      dueDateTo.hashCode;
}
