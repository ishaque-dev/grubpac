import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/team/data/models/member_model.dart';

abstract interface class ITeamRemoteDs {
  Future<List<MemberModel>> getMembers({required UserSessionModel session});
}
