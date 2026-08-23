import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/features/notifications/domain/entities/notification_entity.dart';
import 'package:grubpac/features/notifications/domain/use_cases/get_notifications_use_case.dart';
import 'package:grubpac/features/notifications/domain/use_cases/toggle_notification_read_use_case.dart';
import 'package:grubpac/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/error/common_failures.dart';

class MockGetNotificationsUseCase extends Mock implements GetNotificationsUseCase {}
class MockToggleNotificationReadUseCase extends Mock implements ToggleNotificationReadUseCase {}

void main() {
  late NotificationBloc bloc;
  late MockGetNotificationsUseCase getNotifications;
  late MockToggleNotificationReadUseCase toggleRead;

  final tSession = UserSessionEntity(
    userId: '1',
    organizationId: '1',
    role: UserRole.orgAdmin,
    accessToken: 'access',
    refreshToken: 'refresh',
    accessTokenExpiresAt: DateTime.now().add(const Duration(hours: 1)),
    refreshTokenExpiresAt: DateTime.now().add(const Duration(days: 1)),
  );

  final tNotification = NotificationEntity(
    notificationId: '1',
    userId: '1',
    taskId: 'task1',
    type: 'assignment',
    message: 'New task assigned',
    hasRead: false,
    createdAt: DateTime.now().toIso8601String(),
  );

  setUp(() {
    getNotifications = MockGetNotificationsUseCase();
    toggleRead = MockToggleNotificationReadUseCase();
    bloc = NotificationBloc(
      getNotifications: getNotifications,
      toggleRead: toggleRead,
    );

    registerFallbackValue(tSession);
    registerFallbackValue(ToggleNotificationReadParams(
      session: tSession,
      notification: tNotification,
    ));
  });

  test('initial state should be NotificationInitial', () {
    expect(bloc.state, NotificationInitial());
  });

  blocTest<NotificationBloc, NotificationState>(
    'emits [NotificationLoading, NotificationLoaded] when NotificationsLoadRequested is successful',
    build: () {
      when(() => getNotifications(parameters: any(named: 'parameters')))
          .thenAnswer((_) async => right([tNotification]));
      return bloc;
    },
    act: (bloc) => bloc.add(NotificationsLoadRequested(tSession)),
    expect: () => [
      NotificationLoading(),
      NotificationLoaded(notifications: [tNotification]),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits [NotificationLoaded] when NotificationToggleReadRequested is successful',
    build: () {
      final updated = tNotification.copyWith(hasRead: true);
      when(() => toggleRead(parameters: any(named: 'parameters')))
          .thenAnswer((_) async => right(updated));
      return bloc;
    },
    seed: () => NotificationLoaded(notifications: [tNotification]),
    act: (bloc) => bloc.add(NotificationToggleReadRequested(
      session: tSession,
      notification: tNotification,
    )),
    expect: () => [
      NotificationLoaded(notifications: [tNotification.copyWith(hasRead: true)]),
    ],
  );

  blocTest<NotificationBloc, NotificationState>(
    'emits [NotificationFailure] when NotificationsLoadRequested fails',
    build: () {
      when(() => getNotifications(parameters: any(named: 'parameters')))
          .thenAnswer((_) async => left(DefaultFailure(message: 'Error')));
      return bloc;
    },
    act: (bloc) => bloc.add(NotificationsLoadRequested(tSession)),
    expect: () => [
      NotificationLoading(),
      NotificationFailure('Error'),
    ],
  );
}
