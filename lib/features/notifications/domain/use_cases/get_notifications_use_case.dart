import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/notifications/domain/entities/notification_entity.dart';
import 'package:grubpac/features/notifications/domain/repo/i_notification_repo.dart';

class GetNotificationsUseCase
    implements UseCase<List<NotificationEntity>, UserSessionEntity> {
  // ignore: prefer_initializing_formals
  const GetNotificationsUseCase({required this._repository});

  final INotificationRepo _repository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call({
    required UserSessionEntity parameters,
  }) =>
      _repository.getNotifications(userSession: parameters);
}
