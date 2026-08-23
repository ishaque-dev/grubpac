import 'package:grubpac/core/database/db.dart';
import 'package:grubpac/features/notifications/data/data_sources/i_notification_local_ds.dart';
import 'package:grubpac/features/notifications/data/models/notification_model.dart';
import 'package:sqflite/sqflite.dart';

class NotificationLocalDsImpl implements INotificationLocalDs {
  const NotificationLocalDsImpl({required this._databaseHelper});

  final DatabaseHelper _databaseHelper;

  @override
  Future<List<NotificationModel>> getNotifications({required String userId}) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return maps.map((json) {
      return NotificationModel.fromJson(json);
    }).toList();
  }

  @override
  Future<void> saveNotifications({
    required List<NotificationModel> notifications,
  }) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();
    for (final n in notifications) {
      batch.insert(
        'notifications',
        n.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> saveNotification({required NotificationModel notification}) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'notifications',
      notification.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteNotification({required String id}) async {
    final db = await _databaseHelper.database;
    await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }
}
