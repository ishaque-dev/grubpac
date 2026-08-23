import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/common_failures.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/notifications/data/data_sources/i_notification_local_ds.dart';
import 'package:grubpac/features/notifications/data/data_sources/i_notification_remote_ds.dart';
import 'package:grubpac/features/notifications/data/models/notification_model.dart';
import 'package:grubpac/features/notifications/domain/entities/notification_entity.dart';
import 'package:grubpac/features/notifications/domain/repo/i_notification_repo.dart';

class NotificationRepoImpl implements INotificationRepo {
  // ignore: prefer_initializing_formals
  const NotificationRepoImpl({
    required this._remoteDs,
    required this._localDs,
  });

  final INotificationRemoteDs _remoteDs;
  final INotificationLocalDs _localDs;

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required UserSessionEntity userSession,
  }) async {
    final sessionModel = UserSessionModel.fromEntity(userSession);
    try {
      final models = await _remoteDs.getNotifications(session: sessionModel);
      await _localDs.saveNotifications(notifications: models);
      return right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      try {
        final localModels = await _localDs.getNotifications(userId: userSession.userId);
        return right(localModels.map((m) => m.toEntity()).toList());
      } catch (cacheError) {
        return left(DefaultFailure(message: cacheError.toString(), cause: e));
      }
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> toggleNotificationRead({
    required UserSessionEntity userSession,
    required NotificationEntity notification,
  }) async {
    final sessionModel = UserSessionModel.fromEntity(userSession);
    final updatedEntity = notification.copyWith(hasRead: !notification.hasRead);
    final model = NotificationModel.fromEntity(updatedEntity);

    try {
      final updatedModel = await _remoteDs.updateNotification(
        notification: model,
        session: sessionModel,
      );
      await _localDs.saveNotification(notification: updatedModel);
      return right(updatedModel.toEntity());
    } catch (e) {
      try {
        await _localDs.saveNotification(notification: model);
        return right(updatedEntity);
      } catch (localError) {
        return left(DefaultFailure(message: localError.toString(), cause: e));
      }
    }
  }
}
