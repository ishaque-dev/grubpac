import 'package:grubpac/core/constants/app_strings.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDb();
    return _database!;
  }

  Future<Database> _openDb() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, AppStrings.dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await _createOrganizationsTable(db);
    await _createUsersTable(db);
    await _createOrganizationMembersTable(db);
    await _createProjectsTable(db);
    await _createTasksTable(db);
    await _createCommentsTable(db);
    await _createNotificationsTable(db);
  }

  Future<void> _createOrganizationsTable(Database db) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS organizations(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      created_at TEXT NOT NULL
    )''');
  }

  Future<void> _createUsersTable(Database db) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS users(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      avatar_url TEXT
    )''');
  }

  Future<void> _createOrganizationMembersTable(Database db) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS org_members(
      org_id TEXT NOT NULL,
      user_id TEXT NOT NULL,
      role TEXT NOT NULL,
      PRIMARY KEY (org_id, user_id)
    )''');
    await db.execute(
      '''CREATE INDEX IF NOT EXISTS idx_org_members_user ON org_members(user_id);''',
    );
  }

  Future<void> _createTasksTable(Database db) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS tasks(
      id TEXT PRIMARY KEY,
      project_id TEXT NOT NULL,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      status TEXT NOT NULL,
      priority TEXT NOT NULL,
      assignee_id TEXT,
      due_date TEXT NOT NULL,
      created_at TEXT NOT NULL
    )''');

    await db.execute(
      '''CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);''',
    );
    await db.execute(
      '''CREATE INDEX IF NOT EXISTS idx_tasks_priority ON tasks(priority);''',
    );
    await db.execute(
      '''CREATE INDEX IF NOT EXISTS idx_tasks_title ON tasks(title);''',
    );
    await db.execute(
      '''CREATE INDEX IF NOT EXISTS idx_tasks_project ON tasks(project_id);''',
    );
  }

  Future<void> _createProjectsTable(Database db) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS projects(
      id TEXT PRIMARY KEY,
      org_id TEXT NOT NULL,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      task_count INTEGER NOT NULL,
      status TEXT NOT NULL,
      created_at TEXT NOT NULL
    )''');

    await db.execute(
      '''CREATE INDEX IF NOT EXISTS idx_projects_organization ON projects(org_id);''',
    );
  }

  Future<void> _createCommentsTable(Database db) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS comments(
      id TEXT PRIMARY KEY,
      task_id TEXT NOT NULL,
      author_id TEXT NOT NULL,
      body TEXT NOT NULL,
      created_at TEXT NOT NULL
    )''');
    await db.execute(
      '''CREATE INDEX IF NOT EXISTS idx_comments_task ON comments(task_id);''',
    );
  }

  Future<void> _createNotificationsTable(Database db) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS notifications(
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      type TEXT NOT NULL,
      task_id TEXT,
      message TEXT NOT NULL,
      read INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL
    )''');
    await db.execute(
      '''CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id);''',
    );
  }
}
