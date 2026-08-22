import 'package:grubpac/core/database/db.dart';
import 'package:grubpac/features/auth/data/models/user_session_model.dart';
import 'package:grubpac/features/projects/data/data_sources/i_projects_local_ds.dart';
import 'package:grubpac/features/projects/data/models/project_model.dart';
import 'package:sqflite/sqflite.dart';

class ProjectsLocalDsImpl implements IProjectsLocalDs {
  ProjectsLocalDsImpl({required this._databaseHelper});

  final DatabaseHelper _databaseHelper;

  @override
  Future<List<ProjectModel>> getProjects({
    required UserSessionModel session,
  }) async {
    final database = await _databaseHelper.database;
    final rows = await database.query(
      'projects',
      where: 'org_id = ?',
      whereArgs: [session.organizationId],
      orderBy: 'created_at ASC',
    );
    return rows.map(ProjectModel.fromJson).toList(growable: false);
  }

  @override
  Future<void> saveProjects({required List<ProjectModel> projects}) async {
    final database = await _databaseHelper.database;
    await database.transaction((transaction) async {
      for (final project in projects) {
        await transaction.insert(
          'projects',
          project.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<void> saveProject({required ProjectModel project}) {
    return saveProjects(projects: [project]);
  }

  @override
  Future<void> deleteProject({required String projectId}) async {
    final database = await _databaseHelper.database;
    await database.delete('projects', where: 'id = ?', whereArgs: [projectId]);
  }
}
