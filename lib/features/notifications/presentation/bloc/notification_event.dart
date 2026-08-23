part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

final class NotificationsLoadRequested extends NotificationEvent {
  const NotificationsLoadRequested(this.session);
  final UserSessionEntity session;

  @override
  List<Object?> get props => [session];
}

final class NotificationToggleReadRequested extends NotificationEvent {
  const NotificationToggleReadRequested({
    required this.session,
    required this.notification,
  });

  final UserSessionEntity session;
  final NotificationEntity notification;

  @override
  List<Object?> get props => [session, notification];
}
