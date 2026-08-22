import 'package:fpdart/fpdart.dart' show Either;
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/auth/domain/repo/i_auth_repo.dart';

class RefreshSessionUseCase implements UseCase<UserSessionEntity, NoParam> {
  final IAuthRepo authRepo;

  RefreshSessionUseCase({required this.authRepo});

  @override
  Future<Either<Failure, UserSessionEntity>> call({
    required NoParam parameters,
  }) {
    return authRepo.refreshSession();
  }
}
