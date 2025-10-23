import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technical_test_project/domain/entities/user.dart';
import 'package:technical_test_project/domain/repositories/user_repository.dart';
import 'package:technical_test_project/domain/usecases/update_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository repository;
  late UpdateUser usecase;

  setUp(() {
    repository = MockUserRepository();
    usecase = UpdateUser(repository);
  });

  test('debe actualizar el usuario correctamente', () async {
    const user =
        User(id: 1, name: 'Juan', lastname: 'Pérez', email: 'jp@test.com');

    when(() => repository.updateUser(user)).thenAnswer((_) async {});

    await usecase(user);

    verify(() => repository.updateUser(user)).called(1);
  });
}
