import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/tasks/data/models/task_model.dart';

abstract interface class ITaskLocalDs {
  Future<List<TaskModel>> getTasks({
    required String projectId,
    required UserSessionModel session,
  });

  Future<TaskModel?> getTaskById({
    required String taskId,
    required UserSessionModel session,
  });

  Future<void> saveTasks({required List<TaskModel> tasks});

  Future<void> saveTask({required TaskModel task});

  Future<void> deleteTask({required String taskId});
}
