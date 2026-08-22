import 'package:fpdart/fpdart.dart' show Either;
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/auth/domain/repo/i_auth_repo.dart';

class LogoutUseCase implements UseCase<void, NoParam> {
  final IAuthRepo authRepo;

  LogoutUseCase({required this.authRepo});

  @override
  Future<Either<Failure, void>> call({
    required NoParam parameters,
  }) {
    return authRepo.logout();
  }
}
