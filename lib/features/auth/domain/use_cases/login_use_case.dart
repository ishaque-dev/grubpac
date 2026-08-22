import 'package:fpdart/fpdart.dart' show Either;
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/auth/domain/entities/auth_request_entity.dart';
import 'package:grubpac/features/auth/domain/repo/i_auth_repo.dart';

class LoginUseCase implements UseCase<UserSessionEntity, AuthRequestEntity> {
  final IAuthRepo authRepo;

  LoginUseCase({required this.authRepo});
  @override
  Future<Either<Failure, UserSessionEntity>> call({
    required AuthRequestEntity parameters,
  }) {
    return authRepo.login(request: parameters);
  }
}
