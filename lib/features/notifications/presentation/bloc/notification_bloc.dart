import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/features/notifications/domain/entities/notification_entity.dart';
import 'package:grubpac/features/notifications/domain/use_cases/get_notifications_use_case.dart';
import 'package:grubpac/features/notifications/domain/use_cases/toggle_notification_read_use_case.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  // ignore: prefer_initializing_formals
  NotificationBloc({
    required this._getNotifications,
    required this._toggleRead,
  })  : super(NotificationInitial()) {
    on<NotificationsLoadRequested>(_onLoadRequested);
    on<NotificationToggleReadRequested>(_onToggleReadRequested);
  }

  final GetNotificationsUseCase _getNotifications;
  final ToggleNotificationReadUseCase _toggleRead;

  Future<void> _onLoadRequested(
    NotificationsLoadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await _getNotifications(parameters: event.session);
    result.fold(
      (failure) => emit(NotificationFailure(failure.message)),
      (notifications) => emit(NotificationLoaded(notifications: notifications)),
    );
  }

  Future<void> _onToggleReadRequested(
    NotificationToggleReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final previous = state is NotificationLoaded
        ? (state as NotificationLoaded).notifications
        : <NotificationEntity>[];

    final result = await _toggleRead(
      parameters: ToggleNotificationReadParams(
        session: event.session,
        notification: event.notification,
      ),
    );

    result.fold(
      (failure) => emit(NotificationFailure(failure.message)),
      (updated) {
        final newList = previous.map((n) {
          return n.notificationId == updated.notificationId ? updated : n;
        }).toList();
        emit(NotificationLoaded(notifications: newList));
      },
    );
  }
}
