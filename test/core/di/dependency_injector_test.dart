import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:technical_test_project/core/di/dependency_injector.dart';
import 'package:technical_test_project/data/datasource/local/user_local_datasource.dart';
import 'package:technical_test_project/data/repositories/user_repository_impl.dart';
import 'package:technical_test_project/domain/repositories/user_repository.dart';
import 'package:technical_test_project/domain/usecases/usecases.dart';
import 'package:technical_test_project/presentation/bloc/user_bloc.dart';

void main() {
  final sl = GetIt.instance;

  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    await sl.reset();
  });

  group('initDependencies', () {
    test('debe registrar todas las dependencias correctamente', () async {
      // Ejecutamos la función principal
      await initDependencies();

      // ===== Verificaciones de dependencias registradas =====
      expect(sl.isRegistered<Database>(), isTrue,
          reason: 'Database no registrada');
      expect(sl.isRegistered<UserLocalDataSource>(), isTrue,
          reason: 'Datasource no registrado');
      expect(sl.isRegistered<UserRepository>(), isTrue,
          reason: 'Repositorio no registrado');

      // UseCases
      expect(sl.isRegistered<AddUser>(), isTrue);
      expect(sl.isRegistered<DeleteUser>(), isTrue);
      expect(sl.isRegistered<GetUserById>(), isTrue);
      expect(sl.isRegistered<GetUsers>(), isTrue);
      expect(sl.isRegistered<UpdateUser>(), isTrue);

      // Bloc
      expect(sl.isRegistered<UserBloc>(), isTrue);

      // ===== Prueba de resolución real =====
      final db = sl<Database>();
      final local = sl<UserLocalDataSource>();
      final repo = sl<UserRepository>();
      final getUsers = sl<GetUsers>();
      final bloc = sl<UserBloc>();

      // Verificamos tipos concretos
      expect(db, isA<Database>());
      expect(local, isA<UserLocalDataSource>());
      expect(repo, isA<UserRepositoryImpl>());
      expect(getUsers, isA<GetUsers>());
      expect(bloc, isA<UserBloc>());
    });

    test('debe permitir múltiples resoluciones sin lanzar errores', () async {
      await initDependencies();

      final firstBloc = sl<UserBloc>();
      final secondBloc = sl<UserBloc>();

      // Factories deben crear instancias nuevas
      expect(firstBloc, isNot(same(secondBloc)));
    });
  });
}
