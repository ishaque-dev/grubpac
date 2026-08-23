import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/features/notifications/domain/entities/notification_entity.dart';

abstract interface class INotificationRepo {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required UserSessionEntity userSession,
  });
  Future<Either<Failure, NotificationEntity>> toggleNotificationRead({
    required UserSessionEntity userSession,
    required NotificationEntity notification,
  });
}
