import 'package:technical_test_project/domain/repositories/user_repository.dart';

class DeleteUser {
  final UserRepository repository;
  DeleteUser(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteUser(id);
  }
}
