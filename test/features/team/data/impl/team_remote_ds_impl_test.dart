import 'package:flutter_test/flutter_test.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/team/data/impl/team_remote_ds_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('returns only members of the session organization', () async {
    final now = DateTime(2026, 1, 1);
    final members = await TeamRemoteDsImpl().getMembers(
      session: UserSessionModel(
        userId: 'user_001',
        organizationId: 'org_a1b2c3',
        role: UserRole.orgAdmin,
        accessToken: 'token',
        refreshToken: 'refresh',
        accessTokenExpiresAt: now.add(const Duration(hours: 1)),
        refreshTokenExpiresAt: now.add(const Duration(days: 1)),
      ),
    );

    expect(members.map((member) => member.id), [
      'user_001',
      'user_002',
      'user_003',
    ]);
  });
}
