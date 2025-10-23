import 'package:technical_test_project/domain/repositories/user_repository.dart';
import 'package:technical_test_project/domain/entities/user.dart';

class AddUser {
  final UserRepository repository;
  AddUser(this.repository);

  Future<void> call(User user) async {
    await repository.addUser(user);
  }
}
