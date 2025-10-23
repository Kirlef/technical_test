abstract class UserLocalDataSource {
  Future<List<Map<String, dynamic>>> getUsers();
  Future<Map<String, dynamic>?> getUserById(int id);
  Future<void> insertUser(Map<String, dynamic> user);
  Future<void> updateUser(Map<String, dynamic> user);
  Future<void> deleteUser(int id);
}
