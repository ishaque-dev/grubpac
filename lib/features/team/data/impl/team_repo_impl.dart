import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/common_failures.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/team/data/data_sources/i_team_remote_ds.dart';
import 'package:grubpac/features/team/domain/entities/member_entity.dart';
import 'package:grubpac/features/team/domain/repo/i_team_repo.dart';

class TeamRepoImpl implements ITeamRepo {
  const TeamRepoImpl({required this._remoteDs});

  final ITeamRemoteDs _remoteDs;

  @override
  Future<Either<Failure, List<MemberEntity>>> getMembers({
    required UserSessionEntity session,
  }) async {
    try {
      final members = await _remoteDs.getMembers(
        session: UserSessionModel.fromEntity(session),
      );
      return right(members.map((member) => member.toEntity()).toList());
    } catch (error) {
      return left(DefaultFailure(message: error.toString(), cause: error));
    }
  }
}
