import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/team/data/data_sources/i_team_remote_ds.dart';
import 'package:grubpac/features/team/data/impl/team_repo_impl.dart';
import 'package:grubpac/features/team/data/models/member_model.dart';
import 'package:grubpac/features/team/domain/entities/member_entity.dart';

class MockTeamRemoteDs extends Mock implements ITeamRemoteDs {}

void main() {
  late TeamRepoImpl repo;
  late MockTeamRemoteDs remoteDs;

  final tSession = UserSessionEntity(
    userId: '1',
    organizationId: '1',
    role: UserRole.orgAdmin,
    accessToken: 'access',
    refreshToken: 'refresh',
    accessTokenExpiresAt: DateTime.now().add(const Duration(hours: 1)),
    refreshTokenExpiresAt: DateTime.now().add(const Duration(days: 1)),
  );

  final tMemberModel = MemberModel(
    id: '1',
    name: 'Member 1',
    email: 'member1@example.com',
    avatarUrl: 'https://example.com/avatar.png',
    role: 'Admin',
  );

  final tMemberEntity = tMemberModel.toEntity();

  setUp(() {
    remoteDs = MockTeamRemoteDs();
    repo = TeamRepoImpl(remoteDs: remoteDs);

    registerFallbackValue(UserSessionModel.fromEntity(tSession));
  });

  group('getMembers', () {
    test('should return remote members when remote call is successful', () async {
      when(() => remoteDs.getMembers(session: any(named: 'session')))
          .thenAnswer((_) async => [tMemberModel]);

      final result = await repo.getMembers(session: tSession);

      expect(result.isRight(), true);
      expect(result.getOrElse((_) => []), [tMemberEntity]);
      verify(() => remoteDs.getMembers(session: any(named: 'session'))).called(1);
    });

    test('should return failure when remote call fails', () async {
      when(() => remoteDs.getMembers(session: any(named: 'session')))
          .thenThrow(Exception('Remote failure'));

      final result = await repo.getMembers(session: tSession);

      expect(result.isLeft(), true);
    });
  });

  group('MemberEntity Equality', () {
    test('should support manual equality overrides', () {
      final entity1 = MemberEntity(
        id: '1',
        name: 'Name',
        email: 'email',
        avatarUrl: 'url',
        role: 'role',
      );
      final entity2 = MemberEntity(
        id: '1',
        name: 'Name',
        email: 'email',
        avatarUrl: 'url',
        role: 'role',
      );

      expect(entity1, equals(entity2));
    });
  });
}
