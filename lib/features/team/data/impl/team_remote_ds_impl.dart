import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/utils/mock_data.dart';
import 'package:grubpac/core/utils/parsing_santizer.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/team/data/data_sources/i_team_remote_ds.dart';
import 'package:grubpac/features/team/data/models/member_model.dart';

class TeamRemoteDsImpl implements ITeamRemoteDs {
  @override
  Future<List<MemberModel>> getMembers({
    required UserSessionModel session,
  }) async {
    final data = await MockApiResponse.load();
    final users = _list(data[AppJsonKeys.users]);
    final memberships = _list(data[AppJsonKeys.orgMembers]);
    final memberIds = memberships
        .map(_map)
        .where(
          (membership) =>
              sanitizeWithType<String>(
                membership[AppJsonKeys.organizationId],
              ) ==
              session.organizationId,
        )
        .map(
          (membership) =>
              sanitizeWithType<String>(membership[AppJsonKeys.userId]),
        )
        .toSet();

    return users
        .map(_map)
        .where((user) => memberIds.contains(user[AppJsonKeys.id]))
        .map((user) {
          final membership = memberships
              .map(_map)
              .firstWhere(
                (value) =>
                    sanitizeWithType<String>(
                          value[AppJsonKeys.organizationId],
                        ) ==
                        session.organizationId &&
                    sanitizeWithType<String>(value[AppJsonKeys.userId]) ==
                        sanitizeWithType<String>(user[AppJsonKeys.id]),
              );
          return MemberModel.fromJson({
            ...user,
            AppJsonKeys.role: membership[AppJsonKeys.role],
          });
        })
        .toList(growable: false);
  }

  List<dynamic> _list(dynamic value) =>
      sanitizeWithType<List<dynamic>>(value, defaultValue: <dynamic>[]);

  Map<String, dynamic> _map(dynamic value) =>
      sanitizeWithType<Map<String, dynamic>>(
        value,
        defaultValue: <String, dynamic>{},
      );
}
