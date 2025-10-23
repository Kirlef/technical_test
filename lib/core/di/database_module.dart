import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';

final sl = GetIt.instance;

Future<void> registerDatabaseModule() async {
  final database = await AppDatabase.init();
  sl.registerLazySingleton<Database>(() => database);
}
