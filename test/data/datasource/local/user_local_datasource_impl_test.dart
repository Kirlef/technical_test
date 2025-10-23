import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:technical_test_project/core/database/app_database.dart';

void main() {
  // Configuración inicial para usar sqflite_ffi en tests
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('AppDatabase Tests', () {
    late Database db;

    setUp(() async {
      // Crear base de datos en memoria para cada test
      db = await openDatabase(
        inMemoryDatabasePath,
        version: 2,
        onCreate: AppDatabase.onCreate,
        onUpgrade: AppDatabase.onUpgrade,
      );
    });

    tearDown(() async {
      // Cerrar base de datos después de cada test
      await db.close();
    });

    test('init() debe crear una base de datos válida', () async {
      final database = await AppDatabase.init();

      expect(database, isNotNull);
      expect(database.isOpen, isTrue);

      await database.close();
    });

    test('onCreate debe crear la tabla users con la estructura correcta',
        () async {
      // Verificar que la tabla existe
      final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='users'");

      expect(tables.length, 1);
      expect(tables.first['name'], 'users');

      // Verificar estructura de la tabla
      final columns = await db.rawQuery('PRAGMA table_info(users)');

      expect(columns.length, 6);

      // Verificar columnas específicas
      final columnNames = columns.map((col) => col['name']).toList();
      expect(
          columnNames,
          containsAll(
              ['id', 'name', 'lastname', 'email', 'birthDate', 'addresses']));

      // Verificar que 'id' es PRIMARY KEY
      final idColumn = columns.firstWhere((col) => col['name'] == 'id');
      expect(idColumn['pk'], 1);
    });

    test('AppDatabase.onCreate debe ser llamado directamente', () async {
      await db.close();

      // Crear nueva base de datos llamando onCreate directamente
      db = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: AppDatabase.onCreate,
      );

      // Verificar que la tabla fue creada
      final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='users'");
      expect(tables.length, 1);

      // Verificar que podemos insertar datos
      final userId = await db.insert('users', {
        'name': 'Test',
        'lastname': 'OnCreate',
        'email': 'oncreate@example.com',
        'birthDate': '2006-01-01',
        'addresses': '[]',
      });

      expect(userId, greaterThan(0));
    });

    test('debe permitir insertar un usuario correctamente', () async {
      final userId = await db.insert('users', {
        'name': 'Juan',
        'lastname': 'Pérez',
        'email': 'juan@example.com',
        'birthDate': '1990-01-15',
        'addresses': '{"street": "Calle 123", "city": "Bogotá"}',
      });

      expect(userId, greaterThan(0));

      // Verificar que el usuario fue insertado
      final users =
          await db.query('users', where: 'id = ?', whereArgs: [userId]);
      expect(users.length, 1);
      expect(users.first['name'], 'Juan');
      expect(users.first['email'], 'juan@example.com');
    });

    test('debe permitir consultar usuarios', () async {
      // Insertar datos de prueba
      await db.insert('users', {
        'name': 'María',
        'lastname': 'García',
        'email': 'maria@example.com',
        'birthDate': '1985-03-20',
        'addresses': '[]',
      });

      await db.insert('users', {
        'name': 'Pedro',
        'lastname': 'López',
        'email': 'pedro@example.com',
        'birthDate': '1995-07-10',
        'addresses': '[]',
      });

      final users = await db.query('users');

      expect(users.length, 2);
      expect(users[0]['name'], 'María');
      expect(users[1]['name'], 'Pedro');
    });

    test('debe permitir actualizar un usuario', () async {
      final userId = await db.insert('users', {
        'name': 'Ana',
        'lastname': 'Martínez',
        'email': 'ana@example.com',
        'birthDate': '1988-12-05',
        'addresses': '[]',
      });

      final rowsUpdated = await db.update(
        'users',
        {'email': 'ana.nueva@example.com'},
        where: 'id = ?',
        whereArgs: [userId],
      );

      expect(rowsUpdated, 1);

      final users =
          await db.query('users', where: 'id = ?', whereArgs: [userId]);
      expect(users.first['email'], 'ana.nueva@example.com');
    });

    test('debe permitir eliminar un usuario', () async {
      final userId = await db.insert('users', {
        'name': 'Carlos',
        'lastname': 'Rodríguez',
        'email': 'carlos@example.com',
        'birthDate': '1992-06-30',
        'addresses': '[]',
      });

      final rowsDeleted = await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      expect(rowsDeleted, 1);

      final users =
          await db.query('users', where: 'id = ?', whereArgs: [userId]);
      expect(users.length, 0);
    });

    test(
        'AppDatabase.onUpgrade debe recrear tabla cuando oldVersion < newVersion',
        () async {
      await db.close();

      // Crear base de datos con versión 1
      db = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: AppDatabase.onCreate,
      );

      // Insertar datos en versión 1
      await db.insert('users', {
        'name': 'Usuario',
        'lastname': 'Antiguo',
        'email': 'antiguo@example.com',
        'birthDate': '2007-01-01',
        'addresses': '[]',
      });

      var users = await db.query('users');
      expect(users.length, 1);

      final dbPath = db.path;
      await db.close();

      // Actualizar a versión 2 usando AppDatabase.onUpgrade
      db = await openDatabase(
        dbPath,
        version: 2,
        onCreate: AppDatabase.onCreate,
        onUpgrade: AppDatabase.onUpgrade,
      );

      // Verificar que la tabla fue recreada (debe estar vacía)
      users = await db.query('users');
      expect(users.length, 0);

      // Verificar que la tabla funciona
      final newUserId = await db.insert('users', {
        'name': 'Usuario',
        'lastname': 'Nuevo',
        'email': 'nuevo@example.com',
        'birthDate': '2008-01-01',
        'addresses': '[]',
      });

      expect(newUserId, greaterThan(0));
    });

    test(
        'AppDatabase.onUpgrade debe llamarse cuando hay actualización de versión',
        () async {
      await db.close();

      // Crear base de datos con versión 1
      db = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: AppDatabase.onCreate,
      );

      // Insertar datos
      await db.insert('users', {
        'name': 'Test',
        'lastname': 'Upgrade',
        'email': 'upgrade@example.com',
        'birthDate': '2009-01-01',
        'addresses': '[]',
      });

      final dbPath = db.path;
      await db.close();

      // Actualizar de versión 1 a 3
      db = await openDatabase(
        dbPath,
        version: 3,
        onCreate: AppDatabase.onCreate,
        onUpgrade: AppDatabase.onUpgrade,
      );

      // La tabla debe estar vacía después del upgrade
      final users = await db.query('users');
      expect(users.length, 0);

      // Verificar que la tabla funciona
      final userId = await db.insert('users', {
        'name': 'Post',
        'lastname': 'Upgrade',
        'email': 'postupgrade@example.com',
        'birthDate': '2010-01-01',
        'addresses': '[]',
      });

      expect(userId, greaterThan(0));
    });

    test('debe manejar campos NOT NULL correctamente', () async {
      expect(
        () => db.insert('users', {
          'name': 'Test',
          // Falta lastname (NOT NULL)
          'email': 'test@example.com',
          'addresses': '[]',
        }),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('birthDate puede ser null', () async {
      final userId = await db.insert('users', {
        'name': 'Sin',
        'lastname': 'Fecha',
        'email': 'sinfecha@example.com',
        'birthDate': null,
        'addresses': '[]',
      });

      expect(userId, greaterThan(0));

      final users =
          await db.query('users', where: 'id = ?', whereArgs: [userId]);
      expect(users.first['birthDate'], isNull);
    });
  });
}
