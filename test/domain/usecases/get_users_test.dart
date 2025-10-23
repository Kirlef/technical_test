import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technical_test_project/domain/entities/user.dart';
import 'package:technical_test_project/domain/repositories/user_repository.dart';
import 'package:technical_test_project/domain/usecases/get_users.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository repository;
  late GetUsers usecase;

  setUp(() {
    repository = MockUserRepository();
    usecase = GetUsers(repository);
  });

  test('debe retornar una lista de usuarios', () async {
    const users = [
      User(id: 1, name: 'Juan', lastname: 'Pérez', email: 'jp@test.com'),
      User(id: 2, name: 'Ana', lastname: 'López', email: 'ana@test.com'),
    ];

    when(() => repository.getUsers()).thenAnswer((_) async => users);

    final result = await usecase();

    expect(result, equals(users));
    verify(() => repository.getUsers()).called(1);
  });
}
