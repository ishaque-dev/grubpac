class NotificationEntity {
  final String notificationId;
  final String userId;
  final String taskId;
  final String type;
  final String message;
  final bool hasRead;
  final String createdAt;

  const NotificationEntity({
    required this.notificationId,
    required this.userId,
    required this.taskId,
    required this.type,
    required this.message,
    required this.hasRead,
    required this.createdAt,
  });

  NotificationEntity copyWith({
    String? notificationId,
    String? userId,
    String? taskId,
    String? type,
    String? message,
    bool? hasRead,
    String? createdAt,
  }) {
    return NotificationEntity(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      taskId: taskId ?? this.taskId,
      type: type ?? this.type,
      message: message ?? this.message,
      hasRead: hasRead ?? this.hasRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationEntity &&
          runtimeType == other.runtimeType &&
          notificationId == other.notificationId &&
          userId == other.userId &&
          taskId == other.taskId &&
          type == other.type &&
          message == other.message &&
          hasRead == other.hasRead &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      notificationId.hashCode ^
      userId.hashCode ^
      taskId.hashCode ^
      type.hashCode ^
      message.hashCode ^
      hasRead.hashCode ^
      createdAt.hashCode;
}
