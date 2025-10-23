import 'package:technical_test_project/domain/repositories/user_repository.dart';
import 'package:technical_test_project/domain/entities/user.dart';

class GetUserById {
  final UserRepository repository;
  GetUserById(this.repository);

  Future<User?> call(int id) async {
    return await repository.getUserById(id);
  }
}
