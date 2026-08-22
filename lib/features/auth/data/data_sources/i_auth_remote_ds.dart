import 'package:grubpac/features/auth/data/models/auth_request_model.dart';
import 'package:grubpac/features/auth/data/models/token_response_model.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';

abstract interface class IAuthRemoteDs {
  Future<UserSessionModel> login({required AuthRequestModel request});

  Future<TokenResponseModel> refreshToken({required String refreshToken});
}
