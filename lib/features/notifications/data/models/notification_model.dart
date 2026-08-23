import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/utils/parsing_santizer.dart';
import 'package:grubpac/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String taskId;
  final String type;
  final String message;
  final bool read;
  final String createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.taskId,
    required this.type,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: sanitizeWithType<String>(json[AppJsonKeys.id]),
      userId: sanitizeWithType<String>(json[AppJsonKeys.userId]),
      taskId: sanitizeWithType<String>(json[AppJsonKeys.taskId]),
      type: sanitizeWithType<String>(json[AppJsonKeys.type]),
      message: sanitizeWithType<String>(json[AppJsonKeys.message]),
      read: sanitizeWithType<bool>(json['read']),
      createdAt: sanitizeWithType<String>(json[AppJsonKeys.createdAt]),
    );
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.notificationId,
      userId: entity.userId,
      taskId: entity.taskId,
      type: entity.type,
      message: entity.message,
      read: entity.hasRead,
      createdAt: entity.createdAt,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      notificationId: id,
      userId: userId,
      taskId: taskId,
      type: type,
      message: message,
      hasRead: read,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppJsonKeys.id: id,
      AppJsonKeys.userId: userId,
      AppJsonKeys.taskId: taskId,
      AppJsonKeys.type: type,
      AppJsonKeys.message: message,
      'read': read ? 1 : 0, // For sqflite compatibility
      AppJsonKeys.createdAt: createdAt,
    };
  }

  // Helper for JSON response which might have boolean
  Map<String, dynamic> toRemoteJson() {
    return {
      AppJsonKeys.id: id,
      AppJsonKeys.userId: userId,
      AppJsonKeys.taskId: taskId,
      AppJsonKeys.type: type,
      AppJsonKeys.message: message,
      'read': read,
      AppJsonKeys.createdAt: createdAt,
    };
  }
}
