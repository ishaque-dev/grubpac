import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/features/team/domain/entities/member_entity.dart';
import 'package:grubpac/features/team/domain/use_cases/get_members_use_case.dart';
import 'package:grubpac/features/team/presentation/bloc/team_bloc.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/error/common_failures.dart';

class MockGetMembersUseCase extends Mock implements GetMembersUseCase {}

void main() {
  late TeamBloc bloc;
  late MockGetMembersUseCase getMembers;

  final tSession = UserSessionEntity(
    userId: '1',
    organizationId: '1',
    role: UserRole.orgAdmin,
    accessToken: 'access',
    refreshToken: 'refresh',
    accessTokenExpiresAt: DateTime.now().add(const Duration(hours: 1)),
    refreshTokenExpiresAt: DateTime.now().add(const Duration(days: 1)),
  );

  final tMember = MemberEntity(
    id: '1',
    name: 'Member 1',
    email: 'member1@example.com',
    avatarUrl: 'https://example.com/avatar.png',
    role: 'Admin',
  );

  setUp(() {
    getMembers = MockGetMembersUseCase();
    bloc = TeamBloc(getMembers: getMembers);

    registerFallbackValue(tSession);
  });

  test('initial state should be TeamInitial', () {
    expect(bloc.state, TeamInitial());
  });

  blocTest<TeamBloc, TeamState>(
    'emits [TeamLoading, TeamLoaded] when TeamMembersLoadRequested is successful',
    build: () {
      when(() => getMembers(parameters: any(named: 'parameters')))
          .thenAnswer((_) async => right([tMember]));
      return bloc;
    },
    act: (bloc) => bloc.add(TeamMembersLoadRequested(tSession)),
    expect: () => [
      TeamLoading(),
      TeamLoaded(members: [tMember]),
    ],
  );

  blocTest<TeamBloc, TeamState>(
    'emits [TeamLoading, TeamFailure] when TeamMembersLoadRequested fails',
    build: () {
      when(() => getMembers(parameters: any(named: 'parameters')))
          .thenAnswer((_) async => left(DefaultFailure(message: 'Error')));
      return bloc;
    },
    act: (bloc) => bloc.add(TeamMembersLoadRequested(tSession)),
    expect: () => [
      TeamLoading(),
      TeamFailure('Error'),
    ],
  );
}
