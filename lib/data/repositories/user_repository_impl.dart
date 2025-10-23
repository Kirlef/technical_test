import 'package:technical_test_project/data/datasource/local/user_local_datasource.dart';
import 'package:technical_test_project/data/models/user_model.dart';
import 'package:technical_test_project/domain/repositories/user_repository.dart';
import 'package:technical_test_project/domain/entities/user.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource local;

  UserRepositoryImpl({required this.local});

  @override
  Future<List<User>> getUsers() async {
    final localMaps = await local
        .getUsers();

    final localModels = localMaps
        .map((map) => UserModel.fromJson(map))
        .toList();
    return localModels.map((m) => m.toEntity()).toList();
  }

  @override
  Future<User?> getUserById(int id) async {
    final map = await local.getUserById(id);
    if (map == null) return null;
    return UserModel.fromJson(map).toEntity();
  }

  @override
  Future<void> addUser(User user) async =>
      local.insertUser(UserModel.fromEntity(user).toJson());

  @override
  Future<void> updateUser(User user) async =>
      local.updateUser(UserModel.fromEntity(user).toJson());

  @override
  Future<void> deleteUser(int id) async => local.deleteUser(id);
}
