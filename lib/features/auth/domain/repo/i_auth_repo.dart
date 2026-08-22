import 'package:fpdart/fpdart.dart';
import 'package:grubpac/core/error/failure.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/features/auth/domain/entities/auth_request_entity.dart';

abstract interface class IAuthRepo {
  Future<Either<Failure, UserSessionEntity>> login({AuthRequestEntity request});
}
