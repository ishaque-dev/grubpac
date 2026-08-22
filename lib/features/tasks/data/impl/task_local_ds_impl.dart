import 'package:grubpac/core/database/db.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/tasks/data/data_sources/i_task_local_ds.dart';
import 'package:grubpac/features/tasks/data/models/task_model.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalDsImpl implements ITaskLocalDs {
  TaskLocalDsImpl({required this._databaseHelper});

  final DatabaseHelper _databaseHelper;

  @override
  Future<List<TaskModel>> getTasks({
    required String projectId,
    required UserSessionModel session,
  }) async {
    final database = await _databaseHelper.database;
    final rows = await database.query(
      'tasks',
      where: 'project_id = ?',
      whereArgs: [projectId],
      orderBy: 'created_at ASC',
    );
    return rows.map(TaskModel.fromJson).toList(growable: false);
  }

  @override
  Future<TaskModel?> getTaskById({
    required String taskId,
    required UserSessionModel session,
  }) async {
    final database = await _databaseHelper.database;
    final rows = await database.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
      limit: 1,
    );
    return rows.isEmpty ? null : TaskModel.fromJson(rows.first);
  }

  @override
  Future<void> saveTasks({required List<TaskModel> tasks}) async {
    final database = await _databaseHelper.database;
    await database.transaction((transaction) async {
      for (final task in tasks) {
        await transaction.insert(
          'tasks',
          task.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<void> saveTask({required TaskModel task}) {
    return saveTasks(tasks: [task]);
  }

  @override
  Future<void> deleteTask({required String taskId}) async {
    final database = await _databaseHelper.database;
    await database.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
  }
}
