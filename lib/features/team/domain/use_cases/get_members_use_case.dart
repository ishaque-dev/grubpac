import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/team/domain/entities/member_entity.dart';
import 'package:grubpac/features/team/domain/repo/i_team_repo.dart';

class GetMembersUseCase
    implements UseCase<List<MemberEntity>, UserSessionEntity> {
  const GetMembersUseCase({required this._repository});

  final ITeamRepo _repository;

  @override
  Future<Either<Failure, List<MemberEntity>>> call({
    required UserSessionEntity parameters,
  }) => _repository.getMembers(session: parameters);
}
