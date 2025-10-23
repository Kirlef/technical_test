import 'package:technical_test_project/domain/repositories/user_repository.dart';
import 'package:technical_test_project/domain/entities/user.dart';

class UpdateUser {
  final UserRepository repository;
  UpdateUser(this.repository);

  Future<void> call(User user) async {
    return await repository.updateUser(user);
  }
}
