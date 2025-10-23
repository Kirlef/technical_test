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

    test('_onCreate debe crear la tabla users con la estructura correcta',
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

    test('_onUpgrade debe recrear la tabla cuando la versión cambia', () async {
      // Cerrar la base de datos actual
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
        'lastname': 'Prueba',
        'email': 'test@example.com',
        'birthDate': '2000-01-01',
        'addresses': '[]',
      });

      // Cerrar y reabrir con nueva versión
      await db.close();

      db = await openDatabase(
        inMemoryDatabasePath,
        version: 2,
        onCreate: AppDatabase.onCreate,
        onUpgrade: AppDatabase.onUpgrade,
      );

      // Verificar que la tabla fue recreada (debe estar vacía)
      final users = await db.query('users');
      expect(users.length, 0);

      // Verificar que la tabla sigue existiendo y funcional
      final userId = await db.insert('users', {
        'name': 'Nuevo',
        'lastname': 'Usuario',
        'email': 'nuevo@example.com',
        'birthDate': '2001-01-01',
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
