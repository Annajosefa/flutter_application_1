import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OnionSenseDatabase {
  final String databaseName;
  late Database database;
  OnionSenseDatabase(this.databaseName);

  Future<void> initializeDatabase() async {
    database = await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE settings(id INTEGER PRIMARY KEY, ip TEXT, language TEXT, font_scale DECIMAL(1,1), seen INTEGER);',
      );
      await db.execute(
          'INSERT INTO settings(ip, language, font_scale, seen) VALUES (\'192.168.4.72\', \'en\', 1, 0)');
    });
  }

  void addNotification(String genre, String title, String body) async {
    database.rawInsert(
      'INSERT INTO notifications(genre, title, body, created_at) VAlUES (?, ?, ?, ?)',
      [genre, title, body, DateTime.now().toString()],
    );
  }

  Future<Map<String, dynamic>> loadSettings() async {
    List<Map<String, dynamic>> result = await database
        .rawQuery('SELECT ip, language, font_scale FROM settings WHERE id = 1');
    Map<String, dynamic> settings = {
      'ip': result[0]['ip'],
      'language': result[0]['language'],
      'font_scale': result[0]['font_scale'].toDouble()
    };
    return settings;
  }

  void saveSettings(String ip, String language, double fontScale) async {
    database.rawUpdate(
      'UPDATE settings SET ip = ?, language = ?, font_scale = ?',
      [ip, language, fontScale],
    );
  }

  Future<int> getNotificationRead() async {
    List<Map<String, dynamic>> settingResult =
        await database.rawQuery('SELECT seen FROM settings WHERE id = 1');
    int notificationRead = int.parse(settingResult[0]['seen']);
    return notificationRead;
  }

  void updateUnreadNotifications(int amount) async {
    await database
        .rawUpdate('UPDATE settings SET seen = ? WHERE id = 1', [amount]);
  }
}
