import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technical_test_project/domain/entities/user.dart';
import 'package:technical_test_project/domain/repositories/user_repository.dart';
import 'package:technical_test_project/domain/usecases/add_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository repository;
  late AddUser usecase;

  setUp(() {
    repository = MockUserRepository();
    usecase = AddUser(repository);
  });

  test('debe llamar a repository.addUser con el usuario correcto', () async {
    const user =
        User(id: 1, name: 'Juan', lastname: 'Pérez', email: 'jp@test.com');

    when(() => repository.addUser(user))
        .thenAnswer((_) async => Future.value());

    await usecase(user);

    verify(() => repository.addUser(user)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
