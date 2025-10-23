import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const _dbName = 'users.db';
  static const _dbVersion = 2;

  /// Inicializa la base de datos
  static Future<Database> init() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
    );
  }

  /// Crea la base de datos por primera vez
  static Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        lastname TEXT NOT NULL,
        email TEXT NOT NULL,
        birthDate TEXT,
        addresses TEXT NOT NULL
      )
    ''');
  }

  /// Maneja actualizaciones de versión de base de datos
  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS users');
      await onCreate(db, newVersion);
    }
  }
}

