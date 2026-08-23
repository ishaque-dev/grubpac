import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/notifications/data/data_sources/i_notification_local_ds.dart';
import 'package:grubpac/features/notifications/data/data_sources/i_notification_remote_ds.dart';
import 'package:grubpac/features/notifications/data/impl/notification_repo_impl.dart';
import 'package:grubpac/features/notifications/data/models/notification_model.dart';
import 'package:grubpac/features/notifications/domain/entities/notification_entity.dart';

class MockNotificationRemoteDs extends Mock implements INotificationRemoteDs {}
class MockNotificationLocalDs extends Mock implements INotificationLocalDs {}

void main() {
  late NotificationRepoImpl repo;
  late MockNotificationRemoteDs remoteDs;
  late MockNotificationLocalDs localDs;

  final tSession = UserSessionEntity(
    userId: '1',
    organizationId: '1',
    role: UserRole.orgAdmin,
    accessToken: 'access',
    refreshToken: 'refresh',
    accessTokenExpiresAt: DateTime.now().add(const Duration(hours: 1)),
    refreshTokenExpiresAt: DateTime.now().add(const Duration(days: 1)),
  );

  final tNotificationModel = NotificationModel(
    id: '1',
    userId: '1',
    taskId: 'task1',
    type: 'assignment',
    message: 'New task assigned',
    read: false,
    createdAt: DateTime.now().toIso8601String(),
  );

  final tNotificationEntity = tNotificationModel.toEntity();

  setUp(() {
    remoteDs = MockNotificationRemoteDs();
    localDs = MockNotificationLocalDs();
    repo = NotificationRepoImpl(remoteDs: remoteDs, localDs: localDs);

    registerFallbackValue(UserSessionModel.fromEntity(tSession));
    registerFallbackValue(tNotificationModel);
  });

  group('getNotifications', () {
    test('should return remote notifications and save to local when remote call is successful', () async {
      when(() => remoteDs.getNotifications(session: any(named: 'session')))
          .thenAnswer((_) async => [tNotificationModel]);
      when(() => localDs.saveNotifications(notifications: any(named: 'notifications')))
          .thenAnswer((_) async => {});

      final result = await repo.getNotifications(userSession: tSession);

      expect(result.isRight(), true);
      expect(result.getOrElse((_) => []), [tNotificationEntity]);
      verify(() => remoteDs.getNotifications(session: any(named: 'session'))).called(1);
      verify(() => localDs.saveNotifications(notifications: [tNotificationModel])).called(1);
    });

    test('should return local notifications when remote call fails', () async {
      when(() => remoteDs.getNotifications(session: any(named: 'session')))
          .thenThrow(Exception('Remote failure'));
      when(() => localDs.getNotifications(userId: any(named: 'userId')))
          .thenAnswer((_) async => [tNotificationModel]);

      final result = await repo.getNotifications(userSession: tSession);

      expect(result.isRight(), true);
      expect(result.getOrElse((_) => []), [tNotificationEntity]);
      verify(() => localDs.getNotifications(userId: '1')).called(1);
    });
  });

  group('toggleNotificationRead', () {
    test('should return updated notification from remote and save to local', () async {
      final updatedModel = NotificationModel(
        id: '1',
        userId: '1',
        taskId: 'task1',
        type: 'assignment',
        message: 'New task assigned',
        read: true,
        createdAt: tNotificationModel.createdAt,
      );

      when(() => remoteDs.updateNotification(
            notification: any(named: 'notification'),
            session: any(named: 'session'),
          )).thenAnswer((_) async => updatedModel);
      when(() => localDs.saveNotification(notification: any(named: 'notification')))
          .thenAnswer((_) async => {});

      final result = await repo.toggleNotificationRead(
        userSession: tSession,
        notification: tNotificationEntity,
      );

      expect(result.isRight(), true);
      expect(result.getOrElse((_) => throw Exception()), updatedModel.toEntity());
    });

    test('should update local and return updated entity when remote fails', () async {
       when(() => remoteDs.updateNotification(
            notification: any(named: 'notification'),
            session: any(named: 'session'),
          )).thenThrow(Exception('Remote failure'));
      when(() => localDs.saveNotification(notification: any(named: 'notification')))
          .thenAnswer((_) async => {});

      final result = await repo.toggleNotificationRead(
        userSession: tSession,
        notification: tNotificationEntity,
      );

      expect(result.isRight(), true);
      expect(result.getOrElse((_) => throw Exception()).hasRead, true);
    });
  });

  group('NotificationEntity Equality', () {
    test('should support manual equality overrides', () {
      final entity1 = NotificationEntity(
        notificationId: '1',
        userId: '1',
        taskId: '1',
        type: 'type',
        message: 'msg',
        hasRead: false,
        createdAt: 'now',
      );
      final entity2 = NotificationEntity(
        notificationId: '1',
        userId: '1',
        taskId: '1',
        type: 'type',
        message: 'msg',
        hasRead: false,
        createdAt: 'now',
      );

      expect(entity1, equals(entity2));
    });
  });
}
