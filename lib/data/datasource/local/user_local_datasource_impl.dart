import 'dart:convert';
import 'package:sqflite/sqlite_api.dart';
import 'package:technical_test_project/data/datasource/local/user_local_datasource.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Database db;
  UserLocalDataSourceImpl(this.db);

  @override
  Future<List<Map<String, dynamic>>> getUsers() async {
    final results = await db.query('users');
    // Deserializar las direcciones de cada usuario
    return results.map((user) {
      return {
        ...user,
        'addresses': user['addresses'] != null
            ? jsonDecode(user['addresses'] as String)
            : [],
      };
    }).toList();
  }

  @override
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;

    final user = result.first;
    // Deserializar las direcciones
    return {
      ...user,
      'addresses': user['addresses'] != null
          ? jsonDecode(user['addresses'] as String)
          : [],
    };
  }

  @override
  Future<void> insertUser(Map<String, dynamic> user) async {
    final userToInsert = {
      ...user,
      'addresses': jsonEncode(user['addresses'] ?? []),
    };
    await db.insert('users', userToInsert);
  }

  @override
  Future<void> updateUser(Map<String, dynamic> user) async {
    final userToUpdate = {
      ...user,
      'addresses': jsonEncode(user['addresses'] ?? []),
    };
    await db.update(
      'users',
      userToUpdate,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  @override
  Future<void> deleteUser(int id) async =>
      await db.delete('users', where: 'id = ?', whereArgs: [id]);
}
