import 'package:technical_test_project/domain/repositories/user_repository.dart';
import 'package:technical_test_project/domain/entities/user.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<List<User>> call() async {
    return await repository.getUsers();
  }
}

