import 'package:fpdart/fpdart.dart' show Either;
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/auth/domain/repo/i_auth_repo.dart';

class GetSavedSessionUseCase implements UseCase<UserSessionEntity?, NoParam> {
  final IAuthRepo authRepo;

  GetSavedSessionUseCase({required this.authRepo});

  @override
  Future<Either<Failure, UserSessionEntity?>> call({
    required NoParam parameters,
  }) {
    return authRepo.getSavedSession();
  }
}
