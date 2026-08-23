import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/features/team/domain/entities/member_entity.dart';

abstract interface class ITeamRepo {
  Future<Either<Failure, List<MemberEntity>>> getMembers({
    required UserSessionEntity session,
  });
}
