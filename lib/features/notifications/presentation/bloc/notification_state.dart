part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

final class NotificationInitial extends NotificationState {}

final class NotificationLoading extends NotificationState {}

final class NotificationLoaded extends NotificationState {
  const NotificationLoaded({required this.notifications});
  final List<NotificationEntity> notifications;

  @override
  List<Object?> get props => [notifications];
}

final class NotificationFailure extends NotificationState {
  const NotificationFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
