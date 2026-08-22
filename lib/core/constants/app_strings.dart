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

  static const String descriptionRequired = 'Description is required.';
  static const String descriptionTooLong =
      'Description must be 500 characters or fewer.';
  static const String titleRequired = 'Title is required.';
  static const String titleTooShort = 'Title must be at least 3 characters.';
  static const String titleTooLong = 'Title must be 100 characters or fewer.';
  static const String nameTooLong = 'Name must be 100 characters or fewer.';
}

abstract final class AppUiStrings {
  static const String appName = 'TASKFLOW';
  static const String tagline = 'MANAGE. EXECUTE. DELIVER.';
  static const String signIn = 'SIGN IN';
  static const String emailAddress = 'EMAIL ADDRESS';
  static const String password = 'PASSWORD';
  static const String login = 'LOGIN TO DASHBOARD';
  static const String forgotPassword = 'FORGOT PASSWORD?';
  static const String projects = 'PROJECTS';
  static const String projectName = 'PROJECT NAME';
  static const String taskList = 'TASK LIST';
  static const String all = 'ALL';
  static const String noProjects = 'NO PROJECTS FOUND';
  static const String noTasks = 'NO TASKS IN THIS CATEGORY';
  static const String newProject = 'NEW PROJECT';
  static const String editProject = 'EDIT PROJECT';
  static const String deleteProject = 'DELETE PROJECT';
  static const String deleteProjectQuestion = 'DELETE PROJECT?';
  static const String projectDeleteWarning =
      'This will permanently delete {name}.';
  static const String newTask = 'NEW TASK';
  static const String taskTitle = 'TASK TITLE';
  static const String description = 'DESCRIPTION';
  static const String status = 'STATUS';
  static const String priority = 'PRIORITY';
  static const String dueDate = 'DUE DATE';
  static const String createProject = 'CREATE PROJECT';
  static const String saveChanges = 'SAVE CHANGES';
  static const String createTask = 'CREATE TASK';
  static const String cancel = 'CANCEL';
  static const String delete = 'DELETE';
  static const String edit = 'EDIT PROJECT';
  static const String deleteTask = 'DELETE TASK';
  static const String taskDeleteQuestion =
      'Are you sure you want to delete this task?';
  static const String signOut = 'Sign out';
  static const String projectActions = 'Project actions';
  static const String projectNotFound = 'Project not found';
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
  static const String tasks = 'tasks';
  static const String title = 'title';
  static const String priority = 'priority';
  static const String assigneeId = 'assignee_id';
  static const String dueDate = 'due_date';
}
