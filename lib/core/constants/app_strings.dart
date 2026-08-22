abstract final class AppStrings {
  static const String dbName = 'grubpac.db';

  static const String nameRequired = 'Name is required.';
  static const String nameTooShort = 'Name must be at least 3 characters.';

  static const String emailRequired = 'Email is required.';
  static const String validEmailAddress = 'Enter a valid email address.';
  static const String phoneRequired = 'Phone number is required.';
  static const String validPhone = 'Enter a valid 10-digit phone number.';

  static const String passwordRequired = 'Password is required.';
  static const String passwordTooShort =
      'Password must be at least 6 characters.';
  static const String durationRequired = 'Duration is required.';
  static const String validDuration = 'Enter a valid duration.';
}

abstract final class AppInternalStrings {
  static const String sessionKey = 'user_session';
  static const String mockDataAsset = 'assets/mock-data.json';
  static const String noActiveSession = 'No active session found';
}

abstract final class AppJsonKeys {
  static const String authMock = 'auth_mock';
  static const String testCredentials = 'test_credentials';
  static const String users = 'users';
  static const String mockLoginResponse = 'mock_login_response';
  static const String email = 'email';
  static const String password = 'password';
  static const String id = 'id';
  static const String organizationId = 'org_id';
  static const String role = 'role';
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String accessTokenExpiresInSeconds =
      'access_token_expires_in_seconds';
  static const String refreshTokenExpiresInSeconds =
      'refresh_token_expires_in_seconds';
  static const String userId = 'user_id';
  static const String accessTokenExpiresAt = 'access_token_expires_at';
  static const String refreshTokenExpiresAt = 'refresh_token_expires_at';
  static const String projects = 'projects';
  static const String projectId = 'project_id';
  static const String name = 'name';
  static const String description = 'description';
  static const String taskCount = 'task_count';
  static const String status = 'status';
  static const String createdAt = 'created_at';
}
