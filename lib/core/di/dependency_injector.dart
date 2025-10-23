import 'package:get_it/get_it.dart';
import 'package:technical_test_project/core/di/database_module.dart';
import 'package:technical_test_project/data/datasource/local/user_local_datasource.dart';
import 'package:technical_test_project/data/datasource/local/user_local_datasource_impl.dart';
import 'package:technical_test_project/data/repositories/user_repository_impl.dart';
import 'package:technical_test_project/domain/repositories/user_repository.dart';
import 'package:technical_test_project/domain/usecases/usecases.dart';
import 'package:technical_test_project/presentation/bloc/user_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
 
  await registerDatabaseModule();

  // ===== Datasources =====
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sl.get()),
  );

  // ===== Repositories =====
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(local: sl.get()),
  );

  // ===== Use Cases =====
  sl.registerLazySingleton(() => AddUser(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));
  sl.registerLazySingleton(() => GetUserById(sl()));
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));

  // ===== Bloc =====
  sl.registerFactory<UserBloc>(() => UserBloc(
      getUsers: sl<GetUsers>(),
      getUserById: sl<GetUserById>(),
      addUser: sl<AddUser>(),
      updateUser: sl<UpdateUser>(),
      deleteUser: sl<DeleteUser>()));
}
