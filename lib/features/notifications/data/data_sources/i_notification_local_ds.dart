import 'package:grubpac/features/notifications/data/models/notification_model.dart';

abstract interface class INotificationLocalDs {
  Future<List<NotificationModel>> getNotifications({required String userId});

  Future<void> saveNotifications({required List<NotificationModel> notifications});

  Future<void> saveNotification({required NotificationModel notification});

  Future<void> deleteNotification({required String id});
}
