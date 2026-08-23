import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/notifications/domain/entities/notification_entity.dart';
import 'package:grubpac/features/notifications/domain/repo/i_notification_repo.dart';

class ToggleNotificationReadParams {
  final UserSessionEntity session;
  final NotificationEntity notification;

  const ToggleNotificationReadParams({
    required this.session,
    required this.notification,
  });
}

class ToggleNotificationReadUseCase
    implements UseCase<NotificationEntity, ToggleNotificationReadParams> {
  // ignore: prefer_initializing_formals
  const ToggleNotificationReadUseCase({required this._repository});

  final INotificationRepo _repository;

  @override
  Future<Either<Failure, NotificationEntity>> call({
    required ToggleNotificationReadParams parameters,
  }) =>
      _repository.toggleNotificationRead(
        userSession: parameters.session,
        notification: parameters.notification,
      );
}
