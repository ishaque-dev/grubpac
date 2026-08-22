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
}
