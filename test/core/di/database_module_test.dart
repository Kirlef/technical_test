import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:technical_test_project/core/di/database_module.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  final sl = GetIt.instance;

  setUp(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    sl.reset();
  });

  test('registerDatabaseModule debe registrar una instancia de Database',
      () async {
    await registerDatabaseModule();

    // Comprobar que la instancia fue registrada
    final db = sl<Database>();

    expect(db, isA<Database>());

    // Verificar que la tabla users existe
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='users';",
    );

    expect(tables.isNotEmpty, isTrue);
  });
}
