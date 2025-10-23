import 'package:technical_test_project/domain/entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User?> getUserById(int id);
  Future<void> addUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(int id);
}
