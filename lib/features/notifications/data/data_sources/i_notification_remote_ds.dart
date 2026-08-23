import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/notifications/data/models/notification_model.dart';

abstract interface class INotificationRemoteDs {
  Future<List<NotificationModel>> getNotifications({
    required UserSessionModel session,
  });

  Future<NotificationModel> updateNotification({
    required NotificationModel notification,
    required UserSessionModel session,
  });
}
