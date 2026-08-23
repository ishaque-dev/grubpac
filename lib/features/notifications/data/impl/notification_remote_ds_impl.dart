import 'package:grubpac/core/utils/mock_data.dart';
import 'package:grubpac/core/utils/parsing_santizer.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/notifications/data/data_sources/i_notification_remote_ds.dart';
import 'package:grubpac/features/notifications/data/models/notification_model.dart';

class NotificationRemoteDsImpl implements INotificationRemoteDs {
  List<NotificationModel>? _notifications;

  @override
  Future<List<NotificationModel>> getNotifications({
    required UserSessionModel session,
  }) async {
    await _loadNotifications();
    return _notifications!
        .where((n) => n.userId == session.userId)
        .toList(growable: false);
  }

  @override
  Future<NotificationModel> updateNotification({
    required NotificationModel notification,
    required UserSessionModel session,
  }) async {
    await _loadNotifications();
    final index = _notifications!.indexWhere((n) => n.id == notification.id);
    if (index < 0) throw StateError('Notification not found');
    
    if (_notifications![index].userId != session.userId) {
      throw StateError('Unauthorized');
    }

    _notifications![index] = notification;
    return notification;
  }

  Future<void> _loadNotifications() async {
    if (_notifications != null) return;
    final data = await MockApiResponse.load();
    final values = sanitizeWithType<List<dynamic>>(
      data['notifications'],
      defaultValue: <dynamic>[],
    );
    _notifications = values
        .map(
          (v) => NotificationModel.fromJson(
            sanitizeWithType<Map<String, dynamic>>(
              v,
              defaultValue: <String, dynamic>{},
            ),
          ),
        )
        .toList();
  }
}
